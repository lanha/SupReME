function X = ConvCM(X,FKM,nl,nc,nb)

if nargin == 3
    [nb,n] = size(X);
    nc = n/nl;
end

X = conv2mat(real(ifft2(fft2(conv2im(X,nl,nc,nb)).*FKM)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% define a circular convolution (the same for all bands) accepting a
% matrix  and returnig a matrix
% size(X) is [no_bands_ms,n]
% FKM is the  of the cube containing the fft2 of the convolution kernels
% ConvCM = @(X,FKM)  reshape(real(ifft2(fft2(reshape(X', nl,nc,nb)).*FKM)), nl*nc,nb)';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
