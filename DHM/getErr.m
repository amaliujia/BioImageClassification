%% This function returns the percentage error a given model makes on the input
% You do not need to change this
function [err] = getErr(h, X, Y)
% Input:  h - a scalar vector containinng the model [threshold]
%         X - a 1 by n vector containing the test instances
%         Y - a 1 by n vector containing the test labels
% Output: predictions - a 1 by n vector containing the predicted test labels
err = 0;
n = length(X);
if(n==0)
    return
end
for(i=1:length(X))
    if(X(i) < h && Y(i) == 1)
        err=err+1;
    elseif(X(i) > h && Y(i) == 0)
        err=err+1;
    end
end
err=err/n;
end

