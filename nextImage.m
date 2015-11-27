function features = nextImage
[data,txt]=xlsread('pool.csv');
features=data(randi(size(data,1)),:);
end