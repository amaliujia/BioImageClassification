function leaves = getLeaves(leaves, v, T, nsample)
%% Get all leaf nodes in the subtree Tv rooted at v
% Input:
%       leaves: previously found leaves
%       v: current root node
%       T: tree (cell object of length 3, see DH_SelectCase1.m for details)
%       nsamples: number of samples, 1000
% Output:
%       leaves: leavs in the subtree Tv rooted at v
% Hint: you should implement this function recursively

if T{2}(v) == 1
    leaves = [leaves, v]; 
else
    size = length(T{3});
    for i = 1 : size
        if T{3}(i) ~= v
           continue;
        end
        leaves = getLeaves(leaves, i, T, nsample);
    end
end
end