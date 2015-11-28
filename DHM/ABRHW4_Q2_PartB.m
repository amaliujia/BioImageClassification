%% Automation of Biological Research Homework number 4, question 2, part B Fall 2015
% Authors:  Christopher James Langmead
% Version: 0.2
% Date: 10/11/2015
% Description
% This file contains the code for running the experiments for part B of the second question of the fourth homework.

%% This function runs the experiments (runExperiments) 25 times and plots the results
% You do not need to change this
function ABRHW4_Q2_PartB

noise = 0.0;
boundaryNoise = 0;

% store the error curves
numtrials = 20;
DHM_ERRORS=zeros(numtrials,100); % DHM's generalization errors
RND_ERRORS=zeros(numtrials,100); % random learner's generalization errors

% run the algorithm numtrials times
for(i=1:numtrials)
    display(sprintf('Running experiment %d ...',i))
    [DHMGeneralizationError, RandGeneralizationError] = runExperimentsQ2(noise,boundaryNoise);
    DHM_ERRORS(i,1:length(DHMGeneralizationError))=DHMGeneralizationError;
    RND_ERRORS(i,1:length(RandGeneralizationError))=RandGeneralizationError;
    
    % copy last error to the end so that we can compute means properly
    DHM_ERRORS(i,1+length(DHMGeneralizationError):end)=DHMGeneralizationError(end);
    RND_ERRORS(i,1+length(RandGeneralizationError):end)=RandGeneralizationError(end);
end
DHM_AV_ERRORS = zeros(1,100);DHM_ST_ERRORS = zeros(1,100);
RND_AV_ERRORS = zeros(1,100);RND_ST_ERRORS = zeros(1,100);

for(i=1:size(DHM_AV_ERRORS,2))
    DHM_AV_ERRORS(i) = mean(DHM_ERRORS(:,i));
    DHM_ST_ERRORS(i) = std(DHM_ERRORS(:,i))/sqrt(numtrials);
    RND_AV_ERRORS(i) = mean(RND_ERRORS(:,i));
    RND_ST_ERRORS(i) = std(RND_ERRORS(:,i))/sqrt(numtrials);
end

errorbar(DHM_AV_ERRORS,DHM_ST_ERRORS);
hold on
errorbar(RND_AV_ERRORS,RND_ST_ERRORS,'r');
hold off
legend('DHM','Random')
xlabel('Number of Queries');
ylabel('Generalization Error');
end
