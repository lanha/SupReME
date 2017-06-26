function sam = plotSAM(Xm_im,Xhat_im,d)

% SAM - Spectral angle (on average over the whole image)

X = conv2mat(Xm_im); Xhat = conv2mat(Xhat_im);

bands = d>1;

sam = hyperErrSam(X(bands,:),Xhat(bands,:));
fprintf('SAM = %2.2f \n', sam(1));

