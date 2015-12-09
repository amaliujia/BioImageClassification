%% checks if a given model is consistent with S
% You do not need to change this
function flag = isconsistent(S, Slabels, h, target)
% Input:  S - a n by 26 vector containing the training instances in S
%         SLabels - a 1 by n vector containing the training labels for S
%         h - a scalar creating the threshold of the function
% Output: flag - a scalar that is 1 if the model is consistent with S, 0 otherwise
flag = 1;
[row, ~] = size(S);
for(i=1:row)
    if([1,S(i,:)] * h' < 0 && Slabels(i)==target)
        flag=0;
        return
    end
    if([1,S(i,:)] * h' > 0 && Slabels(i)~=target)
        flag=0;
        return
    end
end
end