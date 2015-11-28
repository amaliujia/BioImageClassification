function [L,loss] = DH_SelectCase1(data, labels, T)
%% Main function for DH algorithm
% Input:
%       data: a 1000 by 25 matrix; each row represents the sample from the
%       ith patient. each column is a protein concentration level
%       labels: an 1000 by 1 matrix; each element (i, 1) represents the
%       true subtype of ith sample.
%       T: a cell of length 3
%           T{1}: the linkage of hierachical clustering tree on data,
%           for more details, please refer to http://www.mathworks.com/help/stats/linkage.html#zmw57dd0e352239
%           T{2}: a vector denoting the size of subtree rooted at each
%           node (the number of children plus 1 for itself)
%           T{3}: a vector denoting the parent for each node, the root
%           node's parent is set to 0
% Output:
%       L: a 1 by 1000 vector; ith element represents the predicted
%       label for ith sample.
%       loss: a 1 by 1000 vector; ith element represents the loss after
%       ith round querying

cnts = zeros(1, 2*length(data)); 
probs = zeros(1, 2*length(data)); 

root = -1; 
for i = 1 : length(T{3})
    if T{3}(i) == 0
        root = i;
        break
    end
end

P = [root];
L = zeros(1, 2*length(data)); 
L(root) = 1;

for i = 1 : length(labels)  
    % Pick a random point z from subtree Tv
    nodes = zeros(1, length(P))
    for j = 1 : length(P)
        nodes(j) = T{2}(j); 
    end
    [~, selected_index] = max(mnrnd(1, nodes / sum(nodes)));
    leaves = getLeaves([], P(selected_index), T, length(labels));
    z = leaves(randi(length(leaves)));
    
    % Query z?s label l
    l_z = labels(z); 
 
    % Update empirical counts and probabilities
    [cnts, probs] = updateEmpirical(cnts, probs, P(selected_index), z, l_z, T);
    [Pbest, Lbest] = chooseBestPruningAndLabeling(cnts, probs, P(selected_index), T, length(labels));
    
    % Update A
    u = P(selected_index);
    P(selected_index) = [];
    P = [P, Pbest];
    L(Pbest) = Lbest;
    L = assignLabels(L, u, u, T, length(labels));
    loss(i) = computeLoss(L(1:length(labels)), labels);
end
for i = 1 : length(P)
    L = assignLabels(L, P(i), P(i), T, length(labels));
end

end
