function loss = computeLoss(L, labels)
%% Compute the loss
% Input:
%       L: labeling of leaf nodes
%       labels: true labels of each node
% Output:
%       loss: squared loss of current prediction
    loss_vec = zeros(1, length(L));
    for i = 1 : length(L)
        if L(i) ~= labels(i)
           loss_vec(i) = 1; 
        end
    end
    loss = sum(loss_vec);
end