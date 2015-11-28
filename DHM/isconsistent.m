%% checks if a given model is consistent with S
% You do not need to change this
function flag = isconsistent(S, Slabels, h)
% Input:  S - a 1 by n vector containing the training instances in S
%         SLabels - a 1 by n vector containing the training labels for S
%         h - a scalar creating the threshold of the function
% Output: flag - a scalar that is 1 if the model is consistent with S, 0 otherwise
flag = 1;
for(i=1:length(S))
    if(S(i)<h && Slabels(i)==1)
        flag=0;
        return
    end
    if(S(i)>h && Slabels(i)==0)
        flag=0;
        return
    end
end
end