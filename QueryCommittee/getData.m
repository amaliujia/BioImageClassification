function [data, labels, T]= getData()
    data = csvread('pool.dat');
    data = data(1:500, :);
    load trueLabels;
    labels = trueLabels(1:500);  
    Z = linkage(data,'ward','euclidean');
    nsample = length(labels);
    parent = zeros(1, Z(end,2)+1);
    parent(end) = 0;
    sub_tree_sizes = zeros(1, Z(end,2)+1);
    sub_tree_sizes(1:nsample) = 1;
    sub_tree_sizes(end) = nsample;
    for i = 1:size(Z,1)
        left = Z(i,1);
        right = Z(i,2);
        current = i + nsample;
        sub_tree_sizes(current) = sub_tree_sizes(left) + sub_tree_sizes(right);
        parent(left) = current;
        parent(right) = current;
    end
    T{1} = Z;
    T{2} = sub_tree_sizes;
    T{3} = parent;
end