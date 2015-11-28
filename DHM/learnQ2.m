%% This function learns a threshold function on the real line from training data. It takes two inputs, S and T. The algorithm
% tries to find a model consisent with S. If it can't, it returns a flag.
% If it can, it returns a model that minimizes the error on T, while still
% being consistent with S.
% You do not need to change this
function [h,flag] = learnQ2(S, T, Slabels, Tlabels)
% Input:  S - a 1 by n vector containing the training instances in S
%         T - a 1 by m vector containing the training instances in T
%         SLabels - a 1 by n vector containing the training labels for S
%         TLabels - a 1 by m vector containing the training labels for T
% Output: h - a scalar containinng the model [threshold]
%         flag - a scalar that is 0 if the algorithm succeeds, 1 otherwise
flag = 1;
h = 1; % default model, everything is zero

if(length(S)==0 && length(T)==0) % S and T are empty, return default model
    flag = 0;
    return
elseif(length(S)==0) % S is empty, T is not; model is determined by T
    flag = 0;
    if(length(find(Tlabels==1))==0) % there are no positive examples in T, return default model
        % do nothing
    else % find optimal T (we need to do search, because there could be noise in the labels)
        minerr = inf;
        tmp = find(Tlabels==1); % only consider positive labels
        for(i=1:length(tmp))
            t = T(tmp(i));
            err = getErr(t, T, Tlabels);
            if(err<minerr)
                minerr = err;
                h = t;
            end
        end
    end
    return
elseif(length(T)==0) % T is empty, S is not; model is determined by S
    if(length(find(Slabels==1))==0) % there are no positive examples in S; use default model
        flag = 0;
    else % confirm model is consistent
        h = min(S(find(Slabels==1))); %left-most point in S labeled 1
        if(isconsistent(S,Slabels,h)==1) % only keep models that are consistent
            flag = 0;
        end
    end
    return
else % S and T have elements in them
    %--------0--------SR0----?-----SL1------------1------------------------
    if(length(find(Slabels==1))==0 && length(find(Tlabels==1))==0) % neither set has positive examples, use default model
        flag = 0;
    elseif(length(find(Slabels==1))==0) % S doesnt have positive examples, T does
        flag = 0;
        SRO = max(S(find(Slabels==0))); % threshold must be > SRO
        minerr = getErr(1, T, Tlabels);
        for(i=1:length(T))
            if(T(i)>SRO && Tlabels(i)==1) % only consider positive labels with thresholds > SRO
                err = getErr(T(i), T, Tlabels);
                if(err<minerr)
                    minerr = err;
                    h = T(i);
                end
            end
        end
    elseif(length(find(Tlabels==1))==0) % T doesnt have positive examples, S does
        h = min(S(find(Slabels==1))); %left-most point in S labeled 1
        if(isconsistent(S,Slabels,h)==1) % only keep models that are consistent
            flag = 0;
        end
    else % both have positive elements
        %--------0--------SR0----?-----SL1------------1------------------------
        SR0 = max(S(find(Slabels==0))); % threshold must be > SRO
        if(length(SR0)==0) % S doesn't have negative examples
            SR0=0;
        end
        SL1 = min(S(find(Slabels==1))); % threshold must be <= SL1
        if(isconsistent(S,Slabels,SL1)==1) %
            h = SL1;
            flag = 0;
        else % inconsistent model
            return
        end
        minerr = getErr(SL1, T, Tlabels);
        for(i=1:length(T))
            if(T(i)>SR0 && T(i)<=SL1 && Tlabels(i)==1) % only consider positive labels with thresholds > SRO
                if(isconsistent(S,Slabels,T(i))==1)
                    err = getErr(T(i), T, Tlabels);
                    if(err<minerr)
                        minerr = err;
                        h = T(i);
                    end
                end
            end
        end
    end
    return
end
end
