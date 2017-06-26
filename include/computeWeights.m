function W = computeWeights(Y,d,sigmas,nl)

% As in eq. (14) and (15)
% Compute weigts for each pixel based on HR bands
hr_bands = d==1;
hr_bands = find(hr_bands)';
for i=hr_bands
%     grad(:,:,i) = imgradient(conv2im(Y(i,:),nl),'prewitt').^2;
%     Intermediate gives also good results compared to prewitt
    grad(:,:,i) = imgradient(conv2im(Y(i,:),nl),'intermediate').^2;
end
grad = sqrt(max(grad,[],3));
grad = grad / quantile(grad(:),0.95);

Wim = exp(-grad.^2/2/sigmas^2);
Wim(Wim<0.5) = 0.5;

W = conv2mat(Wim,nl);

