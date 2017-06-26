%% Demo for SupReME
% using a simulated Sentinel-2 (S2) from APEX
%
clear
close all
addpath('./include')

% dimension of the subspace
p = 7;      %7 just the number of bands with resolution 10

% regularization parameter
lambda = 0.005; reg_type = 'l2_reg';

% number of MS bands
nb = 12;

% Sequence of bands
% [B1 B2 B3 B4 B5 B6 B7 B8 B8A B9 B11 B12]

% subsampling factors (in pixels)
d = [6 1 1 1 2 2 2 1 2 6 2 2]';

% convolution  operators (Gaussian convolution filters), taken from ref [5]
mtf = [ .32 .26 .28 .24 .38 .34 .34 .26 .33 .26 .22 .23];
sdf = d.*sqrt(-2*log(mtf)/pi^2)';

% Do not sharpen high-res bands
sdf(d==1) = 0;

% remove border for computing the subspace and the result (because of
% circular assumption
limsub = 2;

% kernel filter support
dx = 12;
dy = 12;


%% --- BEGIN  -------------------------------------------------------
% load HSI data set

load apexSample.mat 
% Xm_im is the ground truth
% Yim is the S2 observed image

[Yim2, av] = normaliseData(Yim);
Yim_noNorm = Yim;

%% dimensions of the inputs
[nl,nc] = size(Yim{2});
n = nl*nc;

%% Define blurring operators
FBM = createConvKernel(sdf,d,nl,nc,nb,dx,dy);
% IMPORTANT!!!
% Note that the blur kernels are shifted to accomodate the co-registration
% of real images with different resolutions.

% The same for computing the subspace
FBM2 = createConvKernelSubspace(sdf,nl,nc,nb,dx,dy);

%% Generate LR MS image FOR SUBSPACE

% Upsample image via interpolation
for i=1:nb
%     Yinterp(:,:,i) = ima_interp_spline(Yim{i},d(i));
    Yinterp(:,:,i) = imresize(Yim2{i},d(i));
end
% Y1 is interpolated no additional blurring
Y1 = conv2mat(Yinterp,nl,nc,nb);
Y1im = Yinterp;
clear Yinterp

% Y2 interpolated images blurred to the same ammount (for subspace)
Y2 = ConvCM(Y1,FBM2,nl,nc,nb);
Y2im = conv2im(Y2,nl,nc,nb);
Y2n = conv2mat(Y2im(limsub+1:end-limsub,limsub+1:end-limsub,:));

%%
% SVD analysis

% Y2n is the image for subspace with the removed border
[U,S] = svd(Y2n*Y2n'/n);
U=U(:,1:p);

% Xm_im is the ground truth image
Xm = conv2mat(Xm_im);


% show the projection error for qof band 3
Xp = U*U'*Xm;
Xpim = conv2im(Xp,nl);
figure(40)
imagesc((Xm_im(:,:,1))); figure(gcf)
title ('original band 1')
figure(60)
imagesc((Xm_im(:,:,1)-Xpim(:,:,1))); figure(gcf)
title ('projection error of HR band 1 in the')

plotSRE(Xm_im,Xpim);


%%   subsampling (insert zeros)

[M, Y] = createSubsampling(Yim2,d,nl,nc,nb);

Yim = conv2im(Y,nl,nc,nb);

%% SOLVER

Xhat_im = solverSupReME(Y,FBM,U,d,lambda,nl,nc,nb,reg_type);

% reduce image based on the subspace borders
Xm_im = Xm_im(limsub+1:end-limsub,limsub+1:end-limsub,:);
Xhat_im = Xhat_im(limsub+1:end-limsub,limsub+1:end-limsub,:);
Y1im = Y1im(limsub+1:end-limsub,limsub+1:end-limsub,:);


%% PLOT RESULTS
Xhat_im = unnormaliseData(Xhat_im,av);
Y1im = unnormaliseData(Y1im,av);


sre(:,1) = plotSRE(Xm_im,Xhat_im);
sam = plotSAM(Xm_im,Xhat_im,d);


plotCompareDif(Y1im,Xm_im,Xhat_im,nb,d)


