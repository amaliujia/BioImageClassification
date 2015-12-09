function [ value ] = Logistic(X, alpha)
%LOGISTIC Summary of this function goes here
%   Detailed explanation goes here
value = (X * alpha') / (1 + X*alpha');

end

