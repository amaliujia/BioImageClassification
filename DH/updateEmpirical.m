function [n, p1] = updateEmpirical(n, p1, v, z, l, T)
    %% Update empirical counts and probabilities for all nodes u on path
    % Input:
    %       n: number of points sampled in the subtree rooted at each node
    %       p1: fraction of label = 1 in the subtree rooted at each node
    %       v: selected subtree Tv's root node
    %       z: selected leaf node in subtree Tv
    %       l: queried label for node z
    %       T: tree (cell object of length 3, see DH.m for details)
    % Output:
    %       n: updated number of points sampled in the subtree rooted at each node
    %       p1: updated fraction of label = 1 in the subtree rooted at each node
    while z <= v && z~=0
        l1 = n(z) * p1(z);
        n(z) = n(z) + 1;
        p1(z) = (l1+l)/n(z);
        z = T{3}(z);
    end
end