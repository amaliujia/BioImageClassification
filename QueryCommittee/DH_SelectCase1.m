function [L,loss] = DH_SelectCase1(data, labels, T, data2, labels2, T2, data3, labels3, T3)
%% Main function for DH algorithm
% Input:
%       data: a 5120 by 26 matrix; each row represents the sample from the
%       ith patient. each column is a protein concentration level
%       labels: an 5120 by 1 matrix; each element (i, 1) represents the
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

cnts = zeros(1, 10*length(data));
cnts2 = zeros(1, 10*length(data2)); 
cnts3 = zeros(1, 10*length(data3)); 
probs = [];
probs2 = [];
probs3 = [];

for i = 1 : 8
probs = [probs; zeros(1, 10*length(data))];
probs2 = [probs2; zeros(1, 10*length(data2))];
probs3 = [probs3; zeros(1, 10*length(data3))];
end

root = -1; 
for i = 1 : length(T{3})
    if T{3}(i) == 0
        root = i;
        break
    end
end

root2 = -1; 
for i = 1 : length(T2{3})
    if T2{3}(i) == 0
        root2 = i;
        break
    end
end


root3 = -1; 
for i = 1 : length(T3{3})
    if T3{3}(i) == 0
        root3 = i;
        break
    end
end

P = [root];
P2 = [root2];
P3 = [root3];
L = zeros(1, 10*length(data));
L2 = zeros(1, 10*length(data2)); 
L3 = zeros(1, 10*length(data3)); 
L(root) = 1;
L2(root2) = 1;
L3(root3) = 1;


for i = 1 : length(labels)
    % Pick a random point z from subtree Tv
    nodes = zeros(1, length(P));
    nodes2 = zeros(1, length(P2));
    nodes3 = zeros(1, length(P3));
    for j = 1 : length(P)
        nodes(j) = T{2}(j); 
    end
    
    for j = 1 : length(P2)
        nodes2(j) = T2{2}(j); 
    end
    
    for j = 1 : length(P3)
        nodes3(j) = T3{2}(j); 
    end
    [~, selected_index] = max(mnrnd(1, nodes / sum(nodes)));
    [~, selected_index2] = max(mnrnd(1, nodes2 / sum(nodes2)));
    [~, selected_index3] = max(mnrnd(1, nodes3 / sum(nodes3)));
    leaves = getLeaves([], P(selected_index), T, length(labels));
    leaves2 = getLeaves([], P2(selected_index2), T2, length(labels2));
    leaves3 = getLeaves([], P3(selected_index3), T3, length(labels3));
%     length(leaves)
    z = leaves(randi(length(leaves)));
%     length(leaves2)
    z2 = leaves2(randi(length(leaves2)));
    z3 = leaves3(randi(length(leaves3)));
    
    % Query z?s label l
    l_z = labels(z);
    l_z2 = labels2(z2);
    l_z3 = labels3(z3);
    loss(i) = inf;
    if (l_z ~= 0)
        % Update empirical counts and probabilities
        [cnts, probs(l_z, :)] = updateEmpirical(cnts, probs(l_z, :), P(selected_index), z, l_z, T);
        [Pbest, Lbest] = chooseBestPruningAndLabeling(cnts, probs(l_z, :), P(selected_index), T, length(labels));
        
        % Update A
        if Lbest == 1
            Lbest = l_z;
        end
        u = P(selected_index);
        P(selected_index) = [];
        P = [P, Pbest];
        L(Pbest) = Lbest;
        L = assignLabels(L, u, u, T, length(labels));
    end
    
    tmp_loss = computeLoss(L(1:length(labels)), labels);
    if tmp_loss < loss(i)
        loss(i) = tmp_loss; 
    end
    
    if (l_z2 ~= 0)
        % Update empirical counts and probabilities
        [cnts2, probs2(l_z2, :)] = updateEmpirical(cnts2, probs2(l_z2, :), P2(selected_index2), z2, l_z2, T2);
        [Pbest2, Lbest2] = chooseBestPruningAndLabeling(cnts2, probs2(l_z2, :), P2(selected_index2), T2, length(labels2));
        
        % Update A
        if Lbest2 == 1
            Lbest2 = l_z2;
        end
        u2 = P2(selected_index2);
        P2(selected_index2) = [];
        P2 = [P2, Pbest2];
        L2(Pbest2) = Lbest2;
        L2 = assignLabels(L2, u2, u2, T2, length(labels2));
    end
    
    tmp_loss = computeLoss(L2(1:length(labels2)), labels2);
    if tmp_loss < loss(i)
        loss(i) = tmp_loss; 
    end

    if (l_z3 ~= 0)
        % Update empirical counts and probabilities
        [cnts3, probs3(l_z3, :)] = updateEmpirical(cnts3, probs3(l_z3, :), P3(selected_index3), z3, l_z3, T3);
        [Pbest3, Lbest3] = chooseBestPruningAndLabeling(cnts3, probs3(l_z3, :), P3(selected_index3), T3, length(labels3));
        
        % Update A
        if Lbest3 == 1
            Lbest3 = l_z3;
        end
        u3 = P3(selected_index3);
        P3(selected_index3) = [];
        P3 = [P3, Pbest3];
        L3(Pbest3) = Lbest3;
        L3 = assignLabels(L3, u3, u3, T3, length(labels3));
    end
    
    tmp_loss = computeLoss(L3(1:length(labels3)), labels3);
    if tmp_loss < loss(i)
        loss(i) = tmp_loss; 
    end    
end
for i = 1 : length(P)
    L = assignLabels(L, P(i), P(i), T, length(labels));
end

for i = 1 : length(P2)
    L2 = assignLabels(L2, P2(i), P2(i), T2, length(labels2));
end

for i = 1 : length(P3)
    L3 = assignLabels(L3, P3(i), P3(i), T3, length(labels3));
end

end
