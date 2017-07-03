function plotCompareDif(Y1im,Xm_im,Xhat_im,nb,d)
% Plots the difference in comparison to the ground truth

for i=1:nb
    if d(i)>1
        figure(i*10)
        subplot(121)
        temp0 = min(min(Y1im(:,:,i)));
        temp1 = max(quantile(Y1im(:,:,i),0.99));
        imagesc(Xm_im(:,:,i),[temp0 temp1])
        st = sprintf('ground truth %d, res = %d', i, d(i)*10 );
        title(st)
        subplot(122)
        imagesc(Xm_im(:,:,i)-Xhat_im(:,:,i), [-1000 1000]); colorbar
        %     imagesc(Xhat_im(:,:,i)-Xm_im(:,:,i),[-.8 .8]);colorbar
        %     axis image off
        st = sprintf('diff to GT');
        title(st)
        drawnow
    end
end
