function X = conv2im(X,nl,nc,nb)

if size(X,2)==1
    X = conv2mat(X,nl,nc,nb);
end
if nargin == 2
    [nb,n] = size(X);
    if n==1
        X = conv2mat(X,nl,nc,nb);
    end
    nc = n/nl;
end
X = reshape(X',nl,nc,nb);

