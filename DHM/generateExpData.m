%% This function generates the data for this question.

function [DATA, TRUE_LABELS] = generateExpData()

% Input: filepath - a cvs file that contains feature vectors for images.
%
% Output: DATA - a 5120 by 26 vector of random numbers in [0,1]
%         TRUE_LABELS - a 1 by 5120 vector of labels (0 or 1)

DATA = textread('/Users/amaliujia/Documents/github/BioImageClassification/DHM/pool.csv', '', 'delimiter', ',', ... 
                'emptyvalue', 0.0);
            
load trueLabels;
TRUE_LABELS = trueLabels(1:500);
DATA = DATA(1:500,:);
end