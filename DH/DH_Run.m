function DH_Run
    [data, labels, T] = getData(); % returns data matrix, labels vector, and the hierarchical tree; for more details, please refer to http://www.mathworks.com/help/stats/linkage.html#zmw57dd0e352239
    
    loss_avg = zeros(1, size(data,1)); % initialize the loss vector (one element per data point)
    numtrials = 5; % run 5 times
    for i =1:numtrials
        display(sprintf('  Running trial %d',i))
        [L,loss] = DH_SelectCase1(data, labels', T); % run the DH algorithm; L is the vector of predictions; loss is the loss curve over the iterations
        loss_avg = loss_avg + loss; % add the loss curves
    end
    loss_avg = loss_avg/numtrials; % compute average loss curve
    figure(1)
    plot(loss_avg/length(labels))
    xlabel('Queries')
    ylabel('Generalization Error')
    title('DH')
end