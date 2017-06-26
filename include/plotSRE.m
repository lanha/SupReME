function sre = plotSRE(Xm_im,Xhat_im)
nb = size(Xhat_im,3);
X = conv2mat(Xm_im); Xhat = conv2mat(Xhat_im);
% SRE - signal to reconstrution error
for i=1:nb
    sre(i,1) = 10*log10(sum(X(i,:).^2)/ sum((Xhat(i,:)-X(i,:)).^2));
%     sre(i,1) = ( sum((Xhat(i,:)-X(i,:)).^2)/sum(X(i,:).^2))*255;
    fprintf('SRE(%d) = %2.4f \n', i,sre(i));
end
fprintf('\n');