function FBM2 = createConvKernelSubspace(sdf,nl,nc,nb,dx,dy)

%--------------------------------------------------------------------------
%   Build convolution kernels FOR SUBSPACE!!!!
%--------------------------------------------------------------------------
%
middlel=round((nl+1)/2);
middlec=round((nc+1)/2);

dx = dx+1;
dy = dy+1;

% kernel filters expanded to size [nl,nc]
B = zeros(nl,nc,nb);
% fft2 of kernels
FBM2 = zeros(nl,nc,nb);

s2 = max(sdf);
for i=1:nb
    if sdf(i) < s2
        h = fspecial('gaussian',[dx,dy],sqrt(s2^2-sdf(i)^2));
        B(middlel-(dy-1)/2:middlel+(dy-1)/2,middlec-(dx-1)/2:middlec+(dx-1)/2,i) = h;
%         B((middlel-dy/2+1:middlel+dy/2),(middlec-dx/2+1:middlec+dx/2),i) = h;
        %circularly center
        B(:,:,i)= fftshift(B(:,:,i));
        % normalize
        B(:,:,i) = B(:,:,i)/sum(sum(B(:,:,i)));
        FBM2(:,:,i) = fft2(B(:,:,i));
    else
        % unit impulse
        B(1,1,i) = 1;
        FBM2(:,:,i) = fft2(B(:,:,i));
    end
end
