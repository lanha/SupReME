function X = conv2mat(X,nl,nc,nb)

if ndims(X) == 3
    [nl,nc,nb] = size(X);
    X = reshape(X,nl*nc,nb)';
elseif ndims(squeeze(X)) == 2
    nb = 1;
    [nl,nc] = size(X);
    X = reshape(X,nl*nc,nb)';
end