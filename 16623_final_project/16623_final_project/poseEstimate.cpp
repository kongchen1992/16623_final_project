
#include "poseEstimate.h"

// Use the Armadillo namespace
using namespace arma;

// Normalize structure/landmarks
mat normalizeS(mat S){
    mat t = sum(S, 1)/S.n_cols;
    for(int i=0; i < S.n_rows; i++){
        for (int j=0; j < S.n_cols; j ++){
            S(i, j) = S(i, j) - t(i, 0);
        }
    }
    double a = sum(sum(stddev(S, 1, 1)))/S.n_rows;
    S = S/a;
    return S;
}

double prox_2norm(mat Z, double lam, mat &X){
    mat U;
    vec s;
    mat V;
    svd_econ(U, s, V, Z);
    if(sum(s) <= lam){
        s(0) = 0;
        s(1) = 0;
    }else if (s(0)-s(1) <= lam){
        s(0) = (sum(s)-lam)/2;
        s(1) = s(0);
    }else{
        s(0) = s(0) - lam;
        s(1) = s(1);
    }
    X = U*diagmat(s)*V.t();
    double normX = s(0);
    return normX;
}

// ADMM
mat ssr(mat W, mat B, double lam, double beta){
    // parameters
    double tol = 1e-3;
    
    // data size
    int k = B.n_rows;
    int p = B.n_cols;
    k = k/3;
    
    // Initialization
    mat M = zeros<mat>(2, 3*k);
    vec C = zeros<vec>(k);
    mat E = zeros(W.n_rows, W.n_cols);
    mat T = sum(W, 1)/W.n_cols;
    
    // Auxiliary variables for ADMM
    mat Z = M;
    mat Y = M;
    double mu = 1/(sum(sum(abs(W)))/W.size());
    
    mat BBt = B*B.t();
    
    //flagOD detection
    bool flagOD;
    if(beta > W.max()){  // too large
        flagOD = false;
    }else{
        flagOD = true;
    }
    
    for(int iter=0; iter<1000; iter++){
        // Update Motion matrix Z
        mat Z0 = Z;
        Z = ((W-E-T*ones<mat>(1, p))*B.t()+mu*M+Y)*inv(BBt+mu*eye<mat>(3*k, 3*k));
        
        // Update Motion Matrix M
        mat Q = Z - Y/mu;
        for(int i=0; i<k; i++){
            mat Qsub = Q.submat(0, 3*i, Q.n_rows-1, 3*i+2);
            mat Msub = M.submat(0, 3*i, M.n_rows-1, 3*i+2);
            double normX = prox_2norm(Qsub, lam/mu, Msub);
            M.submat(0, 3*i, M.n_rows-1, 3*i+2) = Msub;
            C(i) = normX;
        }
        
        if(flagOD){
            // Update flagOD term
            E = W - Z*B - T*ones<mat>(1, p);
            E = sign(E) % max(abs(E)-beta, zeros<mat>(size(E)));
            
            // Update translation
            T = sum(W-Z*B-E, 1)/W.n_cols;
        }
        
        // Update dual variable
        Y = Y + mu*(M-Z);
        
        double PrimRes = norm(M-Z, "fro")/norm(Z0, "fro");
        double DualRes = mu*norm(Z-Z0, "fro")/norm(Z0, "fro");
        
        if(iter%10==0){
            cout << "Iter" << iter << ": PrimRes = " << PrimRes << ", DualRes = " << DualRes << ", m = " << mu << endl;
        }
        
        // Convergent?
        if(PrimRes < tol && DualRes < tol){
            break;
        }else{
            if(PrimRes>10*DualRes){
                mu = 2*mu;
            }else if(DualRes>10*PrimRes){
                mu = mu/2;
            }
        }
        
    }
    mat R = zeros<mat>(3, 3*k);
    for(int i=0; i<C.n_elem; i++){
        if(C(i)>1e-6){
            R.submat(0, 3*i, 1, 3*i+2) = M.submat(0, 3*i, W.n_rows-1, 3*i+2)/C(i);
            R.submat(2, 3*i, 2, 3*i+2) = cross(R.submat(0, 3*i, 0, 3*i+2), R.submat(1, 3*i, 1, 3*i+2));
        }
    }
    mat S = R*kron(diagmat(C), eye(3, 3))*B;
    
    return S;
}
