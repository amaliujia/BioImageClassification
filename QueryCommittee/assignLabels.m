function L = assignLabels(L, u, v, T, nsample)
%% Assign labels to every leaf according to the label of the subtree's root node
%   Input:
%       L: predicted label of each node
%       u: current node
%       v: subtree's root node
%       T: tree (cell object of length 3, see DH_SelectCase1.m for details)
%       nsample: number of samples, 1000
%   Output:
%       L: predicted label of each node
% Hint: you should implement this function recursively

% L(getLeaves([], v, T, nsample)) = L (v);

if T{2}(u) == 1
    L(u) = L(v); 
else
    size = length(T{3});
    for i = 1 : size
        if T{3}(i) ~= u
           continue;
        end
        L = assignLabels(L, i, v, T, nsample);
    end
end
end