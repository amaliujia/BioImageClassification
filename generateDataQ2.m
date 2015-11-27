%% This function generates the data for this question.
function [DATA, TRUE_LABELS,TRUE_THRESHOLD] = generateDataQ2(numsamples,noise,boundaryNoise)
% Input:  numsamples - the number of samples to generate
%         noise - a number in the range (0,1) to determine which percentage
%         of the data are noise
%         boundaryNoise - a flag that determines whether the noise (if any) is concentrated on the boundary
% Output: DATA - a 1 by numsamples vector of random numbers in [0,1]
%         TRUE_LABELS - a 1 by numsamples vector of labels (0 or 1)
%         TRUE_THRESHOLD  - a scalar containing the true threshold
TRUE_THRESHOLD = .5;
TRUE_LABELS = zeros(1,numsamples);
DATA = rand(1,numsamples);
for(i=1:numsamples)
    if(DATA(i)>=TRUE_THRESHOLD)
        TRUE_LABELS(i) = 1;
    end
    if(boundaryNoise==0 && noise>0)
        if(rand<noise)
            TRUE_LABELS(i) = abs(1-TRUE_LABELS(i));
        end
    elseif(boundaryNoise==1 && noise>0)
        
        t = (DATA(i) - TRUE_THRESHOLD)/(4*noise) + TRUE_THRESHOLD;
        if(rand<t)
            TRUE_LABELS(i)=1;
        else
            TRUE_LABELS(i)=0;
        end
    end
end
end
