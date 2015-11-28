function [Pbest, Lbest] = chooseBestPruningAndLabeling(n, p1, v, T, nsample)
%% update admissible A and compute scores; find best pruning and labeling
%   Input:
%       n: number of points sampled in the subtree rooted at each node
%       p1: fraction of label = 1 in the subtree rooted at each node
%       v: selected subtree Tv's root node
%       T: tree (cell object of length 3, see DH_SelectCase1.m for details)
%       nsample: number of samples, 1000
%   Output:
%       Pbest: the best new pruning
%       Lbest: the best labeling for v
    p0_LB = max(1-p1 - (1./n + sqrt(p1.*(1-p1)./n)), 0);
    p1_LB = max(p1 - (1./n + sqrt(p1.*(1-p1)./n)), 0);
    A0 = p0_LB > 1/3;
    A1 = p1_LB > 1/3;
    e1 = 1-p1;
    e1_tilde = zeros(1, length(e1))+1;
    e1_tilde(A1) = e1(A1); 
    e0 = p1;
    e0_tilde = zeros(1, length(e0))+1;
    e0_tilde(A0) = e1(A0); 
    
    score0 = zeros(1, length(n))+NaN;
    score1 = zeros(1, length(n))+NaN;
    score = zeros(1, length(n));
    for i = 1:length(n)
        parent = T{3}(i);
        if parent == 0 
            break
        end
        if A0(i)
            if isnan(score0(parent))
                score0(parent) = T{2}(i)/T{2}(parent)*score(i);
            else
                score0(parent) = score0(parent) + T{2}(i)/T{2}(parent)*score(i);
            end
        end
        if A1(i)
            if isnan(score1(parent))
                score1(parent) = T{2}(i)/T{2}(parent)*score(i);
            else
                score1(parent) = score1(parent) + T{2}(i)/T{2}(parent)*score(i);
            end
        end
       
        score(i) = min([score0(i), score1(i), e0_tilde(i), e1_tilde(i)]);
    end
    score(end) = min([score0(end), score1(end), e0_tilde(end), e1_tilde(end)]);
    Pbest = [];
    [~, best] = min([score0(v), score1(v), e0_tilde(v), e1_tilde(v)]);
    if best == 1
        Lbest = 0;
        if v <= nsample
            Pbest = [v];
        else
            left = T{1}(v-nsample, 1);
            right = T{1}(v-nsample, 2);
            Pbest = [left, right];
        end
    elseif best == 2
        Lbest = 1;
        if v <= nsample
            Pbest = [v];
        else
            left = T{1}(v-nsample, 1);
            right = T{1}(v-nsample, 2);
            Pbest = [left, right];
        end
    elseif best == 3
        Lbest = 0;
        Pbest = [v];
    else
        Lbest = 1;  
        Pbest = [v];
    end
    
    
end