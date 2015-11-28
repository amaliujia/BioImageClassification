%% Automation of Biological Research Homework number 4, question 2, part C Fall 2015
% Authors:  Christopher James Langmead
% Version: 0.2
% Date: 10/11/2015
% Description
% This file contains the code for running the experiments for part C of the second question of the fourth homework.

%% This function runs the experiments (runExperiments) 25 times and plots the results
% You do not need to change this
function ABRHW4_Q2_PartC

% store the error curves
numtrials = 20;
for(expertiments=1:5)
    if(expertiments == 1)
        noise = 0.0;
        boundaryNoise = 0;
    elseif(expertiments==2)
        noise = 0.1;
        boundaryNoise = 0;
    elseif(expertiments==3)
        noise = 0.2;
        boundaryNoise = 0;
    elseif(expertiments==4)
        noise = 0.1;
        boundaryNoise = 1;
    elseif(expertiments==5)
        noise = 0.2;
        boundaryNoise = 1;
    end
    
    % run the algorithm numtrials times
    TMP_COSTS=zeros(numtrials,500); 
    for(i=1:numtrials)
        display(sprintf('Running experiment: %d, params noise: %1.1f; boundary noise? %1.0f',i,noise,boundaryNoise))
        [DHMGeneralizationError, RandGeneralizationError,costcurve] = runExperimentsQ2(noise,boundaryNoise);
        TMP_COSTS(i,:)=costcurve;
    end
    
    if(expertiments == 1)
        EX1_COSTS = mean(TMP_COSTS);
    elseif(expertiments==2)
        EX2_COSTS = mean(TMP_COSTS);
    elseif(expertiments==3)
        EX3_COSTS = mean(TMP_COSTS);
    elseif(expertiments==4)
        EX4_COSTS = mean(TMP_COSTS);
    elseif(expertiments==5)
        EX5_COSTS = mean(TMP_COSTS);
    end
end

plot(1:length(EX1_COSTS),EX1_COSTS);
hold on
plot(1:length(EX2_COSTS),EX2_COSTS,'r');
plot(1:length(EX3_COSTS),EX3_COSTS,'g');
plot(1:length(EX4_COSTS),EX4_COSTS,'k');
plot(1:length(EX5_COSTS),EX5_COSTS,'m');
hold off
legend('No noise','random noise 0.1','random noise 0.2','boundary noise 0.1','boundary noise 0.2')
ylabel('Number of Queries');
xlabel('Number of data points seen');
end
