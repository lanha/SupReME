function Xhat_im = solverSupReME(Y,FBM,U,d,tau,nl,nc,nb,reg_type)

%  Solves the multispectral super-resolution with CSALSA and adaptive 
%  quadratic regularization
% 
% 
% Input: 
% Y: observed image (padded with zeros to fit resolutions)
% FBM: Fourier transform of the blur kernels
% U: learnt subspace
% d: resolution differences of the channels (eg 10m: d=1, 20m: d=2, etc)
% tau: weight of the regularizer
% nl, nc, nb: size of the image (3d cube) at highest resolution
% reg_type: the type of the regulariser
% 
% Output: 
% Xhat_im: estimated image (3D) at high resolution for each spectral channel



%%  Quadratic regularization using CSALSA
%
%
%    optimization
%
%        min (1/2)|| M*B*(U kron I))*z - y||^2  + tau* phi( Dh*z, Dv*z )
%         z
%
%    solution computed with CSALSA
%
%           min (1/2)|| M*B*v1 - y||^2 + tau* phi(v2,v3)
%        z,v1,v2,v3
%           subject to  v1 = (U kron I)*z
%                       v2 = Dh*z
%                       v3 = Dv*z
%
%    augmented Lagrangian
%
%            L(z,v,d)  = (1/2)|| M*B*v1 - y||^2 + tau* phi(v2,v3)
%                            + (mu/2)||(U kron I))*z - v1 -d1 ||^2
%                            + (mu/2)||Dh*z - v2 -d2 ||^2
%                            + (mu/2)||Dv*z - v3 -d3 ||^2
% 
%
%  in the following all variables will be represented in matrix (2D) format

% definitions
niters = 100;
mu = 0.2;

p = size(U,2);
n = nl*nc;
FBMC = conj(FBM);
BTY =  ConvCM(Y,FBMC,nl);

% Operators for diferences
dh = zeros(nl,nc);
dh(1,1) = 1;
dh(1,nc) = -1;

dv = zeros(nl,nc);
dv(1,1) = 1;
dv(nl,1) = -1;

FDH = repmat(fft2(dh),1,1,p);
FDV = repmat(fft2(dv),1,1,p);
FDHC = conj(FDH);
FDVC = conj(FDV);

% Compute weights
sigmas = 1;
W = computeWeights(Y,d,sigmas,nl);


IF = 0*FBM;
% build the invserse filter in frequency domain with subsampling
for i=1:nb
        Fim = abs(FBM(:,:,i)).^2;
        Fpatches = im2col(Fim,[nl/d(i),nc/d(i)],'distinct');
        [p1,p2] = size(Fpatches);
        Fpatches = 1./(sum(Fpatches,2)/mu + d(i)^2);   % inv(d^2*I +(1/lambda)*D'*abs(S).^2D)  (image format)
        aux = col2im(repmat(Fpatches,1,p2),[nl/d(i),nc/d(i)], [nl,nc],'distinct');   % D*ans*D' (image format)
        Fim =  Fim.*aux;
        IF(:,:,i) = Fim;
end

IFZ = 1./ (abs(FDH).^2 + abs(FDV).^2 + 1);


% initialization
Z = zeros(p,n);
V1 = zeros(nb,n);
V2 = Z;
V3 = Z;
D1 = V1;
D2 = Z;
D3 = Z;


% SupReME
for i=1:niters

%            min   1/2||(U kron I))*z - v1 -d1 ||^2
%             z              + 1/2||(I kron Dh'))*z - v2 -d2 ||^2
%                            + 1/2||(I kron Dv'))*z - v3 -d3 ||^2
% 
    %   Z = (U'*(V1+D1) + (V2+D2)*Dh' + (V3+D3)*Dv') / (I + DhDh' + DvDv')
  
    Z = ConvCM( U'*(V1+D1) + ConvCM(V2+D2,FDHC,nl) + ConvCM(V3+D3,FDVC,nl), IFZ, nl);

%            min (1/2)|| M*B*v1 - y||^2 
%             v1            + (mu/2)||U*z - v1 -d1 ||^2
%                           
%              V1 = (B'M'MB + muI)\(B'M'Y + mu(U*Z - D1))
%     For more details see [22]:
    NU1 = U*Z-D1;
    AUX = BTY+mu*NU1;
    
    V1 = AUX/mu - ConvCM(AUX,IF,nl)/mu^2;


%            min   tau* phi(v2,v3)
%           v2,v3       + (mu/2)||Dh*z - v2 -d2 ||^2
%                       + (mu/2)||Dv*z - v3 -d3 ||^2
    
%  Here a weighted version is applied with weights W, q
    NU2 =  ConvCM(Z, FDH, nl) - D2;
    NU3 =  ConvCM(Z, FDV, nl) - D3;

    [V2,V3] = regularization(NU2,NU3,tau,mu,W,reg_type);


    % Residuals of variable splitting
    err = norm(NU2+D2-V2,'fro') + norm(NU3+D3-V3,'fro') + norm(NU1+D1-V1,'fro');
    
    if err<1e-3
        break
    end
    
    % update Lagrange multipliers
    D1 = -NU1 + V1;
    D2 = -NU2 + V2;
    D3 = -NU3 + V3;
    

    
end

Xhat = U*Z;
Xhat_im = conv2im(Xhat,nl,nc,nb);



