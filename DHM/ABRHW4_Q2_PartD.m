%% Automation of Biological Research Homework number 4, question 2,part D Fall 2015
% Authors:  Christopher James Langmead
% Version: 0.2
% Date: 10/11/2015
% Description
% This file contains the code for running the experiments for part D of the second question of the fourth homework.

%% This function runs the experiments (runExperiments) 25 times and plots the results
% You do not need to change this
function ABRHW4_Q2_PartD

% store the error curves
numtrials = 20;

noise = 0.2;
boundaryNoise = 1;

% run the algorithm numtrials times
allqueries = [];
for(i=1:numtrials)
    display(sprintf('Running experiment: %d, params noise: %1.1f; boundary noise? %1.0f',i,noise,boundaryNoise))
    [DHMGeneralizationError, RandGeneralizationError,costcurve,queries] = runExperimentsQ2(noise,boundaryNoise);
    allqueries=[allqueries queries];
end
hist(allqueries,20)
ylabel('Counts');
xlabel('X');
end
