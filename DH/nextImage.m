function features = nextImage
data = csvread('pool.dat');
features=data(randi(size(data,1)),:);
end