function sam2 = hyperErrSam(truth, recon)

% result is given in degrees

% for i=1:size(truth,2)
% sam(i) = hyperSam(truth(:,i),recon(:,i));
% end

nom = sum(truth.*recon);
denom1 = sqrt(sum(truth.^2));
denom2 = sqrt(sum(recon.^2));

sam = acos((nom)./(denom1.*denom2));

% this ignores the pixels that have zero norm (all values zero - no color)
ind = ~isnan(sam);
sam2 = mean(sam(ind))*180/pi;
if sum(~ind)~=0;warning('Some values were ignored while computing the SAM');end
