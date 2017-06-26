function [Yim, av] = normaliseData(Yim)

if iscell(Yim)
    % mean squared power = 1
    nb = length(Yim);
    
    for i=1:nb
        av(i,1) = mean2(Yim{i}.^2);
        Yim{i,1} = sqrt(Yim{i}.^2/av(i,1));
%         Yim{i,1} = Yim{i}/av(i,1);
    end
    
else
    nb = size(Yim,3);
    for i=1:nb
        av(i,1) = mean2(Yim(:,:,i).^2);
        Yim(:,:,i) = sqrt(Yim(:,:,i).^2/av(i,1));
%         Yim(:,:,i) = Yim(:,:,i)/av(i,1);
    end
end