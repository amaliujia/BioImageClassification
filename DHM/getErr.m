%% This function returns the percentage error a given model makes on the input
% You do not need to change this
function [err] = getErr(h, X, Y, target)
% Input:  h - a scalar vector containinng the model [threshold]
%         h - a 1 by 26 scalar vector containing the model [threshold]
%         X - a n by 26 matrix containing the test instances
%         Y - a n by 26 matrix containing the test labels
% Output: error - a decimal in [0,1] shows the prediction error.
err = 0;
[n, ~]= size(X);
if(n==0)
    return
end

for i=1:n
    if(([1,X(i,:)] * h' < 0)  && Y(i) == target)
        err=err+1;
    elseif(([1,X(i,:)] * h' > 0) && Y(i) ~= target)
        err=err+1;
    end
end
err=err/n;
end

