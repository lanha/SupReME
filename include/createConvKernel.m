function FBM = createConvKernel(sdf,d,nl,nc,nb,dx,dy)

%--------------------------------------------------------------------------
%   Build convolution kernels
%--------------------------------------------------------------------------
%
middlel=((nl)/2);
middlec=((nc)/2);

% kernel filters expanded to size [nl,nc]
B = zeros(nl,nc,nb);
% fft2 of kernels
FBM = zeros(nl,nc,nb);
for i=1:nb
    if d(i) > 1
        h = fspecial('gaussian',[dx,dy],sdf(i));

        B((middlel-dy/2+1:middlel+dy/2)-d(i)/2+1,(middlec-dx/2+1:middlec+dx/2)-d(i)/2+1,i) = h; %run

        %circularly center
        B(:,:,i)= fftshift(B(:,:,i));
        % normalize
        B(:,:,i) = B(:,:,i)/sum(sum(B(:,:,i)));
        FBM(:,:,i) = fft2(B(:,:,i));
    else
        B(1,1,i) = 1;
        FBM(:,:,i) = fft2(B(:,:,i));
    end
end



