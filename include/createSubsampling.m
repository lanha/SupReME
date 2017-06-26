function [M, Y] = createSubsampling(Yim,d,nl,nc,nb)

% subsampling matrix
M = zeros(nl,nc,nb);
indexes = cell([nb 1]);

for i=1:nb
    im = ones(floor(nl/d(i)),floor(nc/d(i)));
    maux = zeros(d(i));
    maux(1,1) = 1;
    
    M(:,:,i) = kron(im,maux);
    indexes{i} = find(M(:,:,i) == 1);
    Y(i,indexes{i}) = conv2mat(Yim{i},nl/d(i),nc/d(i),1);
end


