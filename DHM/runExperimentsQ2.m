
%% This function runs the DHM and random learner in parallel assuming a streaming data model
function [DHMGeneralizationError, RandGeneralizationError, costcurve, queries] = runExperimentsQ2(noise,boundaryNoise)
% Input:  noise - a number in the range (0,1) to determine which percentage
%         of the data are noise
%         boundaryNoise - a flag that determines whether the noise (if any) is concentrated on the boundary
% Output: DHMGeneralizationError - a vector containing the DHM's generalization error as a function of the number of calls to the oracle
%         RandGeneralizationError - a vector containing the random learner's generalization error as a function of the number of calls to the oracle
%         costcurve - a vector containing the cost curve for the DHM learner
%         queries - a vector containing the instances that were labeled by the oracle

% This question involves implementing the DHM algorithm for learning a
% threshold function on the unit interval.

% Additionally, you will implement a random learner for performing the
% same task and compare the performance of both algorithms

% Read through the code carefully.  The parts that you have to implement
% are labeled with comments, such as  IMPLEMENT THIS

numsamples = 500;

% generate the data. DATA is a 5120 by 26 vector of values
% TRUE_LABELS is a 1 by 5120 vector of labels in the range of [0, 7]
[DATA, TRUE_LABELS] = generateExpData();

%% run the DHM algorithm

% vectors for identifying points in sets S and T
S = zeros(1,numsamples);
T = zeros(1,numsamples);

% Labels for the points in S and T
Slabels = zeros(1,numsamples);
Tlabels = zeros(1,numsamples);

% R is a bit vector indicating which samples have been queried by a random learner
R = zeros(1,numsamples);

% these vectors keep track of the generalization errors for DHM and the random learner
% initial error is calculated assuming the default model predicts all 0's
DHMGeneralizationError = sum(TRUE_LABELS)/numsamples; % compute generalization error
RandGeneralizationError = sum(TRUE_LABELS)/numsamples; % compute generalization

% this is the main loop of the DHM algorithm
cost = 0;  % keeps track of the number of calls to the oracle
costcurve=zeros(1,numsamples);
queries=0;

for t=1:numsamples
    partial_data = [DATA(S==1,:); DATA(t,:)];
    partial_label = [Slabels(S==1), 1];
    h = zeros(9, 27);
    success = zeros(1, 9);
    for i = 1:9
        [h(i,:), flag_c] = learnQ2(partial_data, DATA(T==1,:), partial_label, Tlabels(T==1), i-1);
        if flag_c == 0
            success(i) = 1;
        end
    end
    
    success_index = find(success==1);
     if length(success_index) == 1
%            random_t = success_index(randi(length(success_index)));
            S(t) = 1;
            Slabels(t) = success_index(1)-1; % should be this one.
            costcurve(t) = cost;
            continue;
%       SUnionT = [DATA(S==1,:); DATA(T==1,:)];
%       SUnionTLabels = [Slabels(S==1), Tlabels(T==1)];
%       min_err = inf;
%       min_index = -1;
%       for x = 1:length(success_index)
%           e = getErr(h(success_index(x),:), [SUnionT; DATA(t,:)], [SUnionTLabels, success_index(x)-1], success_index(x)-1);
%           if e < min_err
%             min_err = e;
%             min_index = success_index(x)-1;
%           end
%       end
%       S(t) = 1;            
%       Slabels(t) = min_index; % should be this one.           
%       costcurve(t) = cost;
%       continue;      
      
    end
    
    
%     [h1, flag_1] = learnQ2(partial_data, DATA(T==1), partial_label, Tlabels(T==1));
%     if(flag_1 == 1)
%        S(t) = 1;
%        Slabels(t) = 0;
%        costcurve(t) = cost;
%        continue;
%     end
%     
%     partial_data = [DATA(S==1), DATA(t)];
%     partial_label = [Slabels(S==1), 0];    
%     [h0, flag_2] = learnQ2(partial_data, DATA(T==1), partial_label, Tlabels(T==1));
%     if(flag_2 == 1)
%        S(t) = 1;
%        Slabels(t) = 1;
%        costcurve(t) = cost;
%        continue;
%     end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % compute Delta DO NOT CHANGE THIS!
    delta = 0.01;
    shatterCoeff = 2*(t+1);
    beta = sqrt( (4/t)*log(8*(t^2+t)*shatterCoeff^2/delta) );
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    SUnionT = [DATA(S==1,:); DATA(T==1,:)];
    SUnionTLabels = [Slabels(S==1), Tlabels(T==1)];
    err_h = zeros(1,9);
    for i = 1:9
        err_h(i) = getErr(h(i,:), SUnionT, SUnionTLabels, i-1);
    end
%     err_h0 = getErr(h0, SUnionT, SUnionTLabels);
%     err_h1 = getErr(h1, SUnionT, SUnionTLabels);
    Delta = (beta^2 + beta*(sum(sqrt(err_h))))*.025;
    min_err = inf;
    min_i = -1;
    for i = 1:9
      if err_h(i) < min_err
          min_err = err_h(i);
          min_i = i;
      end
    end
    
    for i = 1:9
       if err_h(i) - min_err > Delta
           S(t) = 1;
           Slabels(t) = min_i-1;
           costcurve(t) = cost;
           continue;
       end
    end
%     if(err_h0 - err_h1 > Delta)
%        S(t) = 1;
%        Slabels(t) = 1;
%        costcurve(t) = cost;
%        continue;        
%     end
%     
%     if(err_h1 - err_h0 > Delta)
%        S(t) = 1;
%        Slabels(t) = 0;
%        costcurve(t) = cost;
%        continue;       
%     end
    
    cost = cost + 1;
    costcurve(t) = cost;
    queries = [queries, t];
    
    Tlabels(t) = TRUE_LABELS(t);
    T(t) = 1;
    [nh, ~] = learnQ2(DATA(S==1,:), DATA(T==1,:), Slabels(S==1), Tlabels(T==1), TRUE_LABELS(t)); 
    % compute error
    DHMGeneralizationError = [DHMGeneralizationError, getErr(nh, DATA, TRUE_LABELS, TRUE_LABELS(t))];
    UR = find(R==0);
    random_i = UR(randi(length(UR)));
    R(random_i) = 1;
    Rlabels(random_i) = TRUE_LABELS(random_i);
    [hh, ~] = learnQ2(zeros(0, 0), DATA(R==1,:), zeros(0, 0), TRUE_LABELS(R==1), TRUE_LABELS(random_i)); 
    RandGeneralizationError = [RandGeneralizationError, getErr(hh, DATA, TRUE_LABELS, TRUE_LABELS(random_i))];
  
end
    
end