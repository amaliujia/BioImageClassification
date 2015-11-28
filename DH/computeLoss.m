function loss = computeLoss(L, labels)
%% Compute the loss
% Input:
%       L: labeling of leaf nodes
%       labels: true labels of each node
% Output:
%       loss: squared loss of current prediction
    loss = sum((L - labels') .* (L - labels'));
end