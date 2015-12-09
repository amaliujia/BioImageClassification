    %% This function learns a threshold function on the real line from training data. It takes two inputs, S and T. The algorithm
% tries to find a model consisent with S. If it can't, it returns a flag.
% If it can, it returns a model that minimizes the error on T, while still
% being consistent with S.
% You do not need to change this
function [h,flag] = learnQ2(dataS, dataT, Slabels, Tlabels, target)
% Input:  dataS - a n by 26 vector containing the training instances in dataS
%         dataT - a m by 26 vector containing the training instances in dataT
%         SLabels - a 1 by n vector containing the training labels for dataS
%         TLabels - a 1 by m vector containing the training labels for dataT
%         target - a number that is target label
% Output: h - a 1 by 26 scalar vector containinng the model [threshold]
%         flag - a scalar that is 0 if the algorithm succeeds, 1 otherwise
flag = 1;
h = ones(1,26); % default model, everything is zero
h = [-1,h];
[rowS, ~] = size(dataS);
[rowT, ~] = size(dataT);

if(rowT == 0 && rowS ==0) % S and T are empty, return default model
    flag = 0;
    return
elseif(rowS == 0) % S is empty, T is not; model is determined by T
    flag = 0;
    if(length(find(Tlabels == target))==0) % there are no positive examples in T, return default model
        % do nothing
    else % find optimal T (we need to do search, because there could be noise in the labels)
%         minerr = inf;
%         tmp = find(Tlabels==1); % only consider positive labels
%         for(i=1:length(tmp))
%             t = dataT(tmp(i),:); % t is temp(i) row in dataT
%             err = getErr(t, dataT, Tlabels);
%             if(err<minerr)
%                 minerr = err;
%                 h = t;
%             end
%         end
        tmp = find(Tlabels==target);
        for i = 1:length(tmp)
           t = dataT(tmp(i),:);
           t = [1, t];
           l = Tlabels(tmp(i));
           if l == target
              l = 1;
           else
              l = 0;
           end
           h = h + 0.05 * (l - t * h') * t;
        end
    end
    return
elseif(rowT==0) % T is empty, S is not; model is determined by S
    if(length(find(Slabels==target))==0) % there are no positive examples in S; use default model
        flag = 0;
    else % confirm model is consistent
        %h = min(S(find(Slabels==target))); %left-most point in S labeled 1
        tmp = find(Slabels==target);
        for i = 1:length(tmp)
           t = dataS(tmp(i),:);
           t = [1, t];
           l = Slabels(tmp(i));
           if l == target
              l = 1;
           else
              l = 0;
           end
           h = h + 0.05 * (l - t * h') * t;
        end        
        
        if(isconsistent(dataS,Slabels, h,target)==1) % only keep models that are consistent
            flag = 0;
        end
    end
    return
else % S and T have elements in them
    %--------0--------SR0----?-----SL1------------1------------------------
    if(length(find(Slabels==target))==0 && length(find(Tlabels==target))==0) % neither set has positive examples, use default model
        flag = 0;
    elseif(length(find(Slabels==target))==0) % S doesnt have positive examples, T does
        flag = 0;
%         SRO = max(S(find(Slabels~=target))); % threshold must be > SRO
%         minerr = getErr(1, T, Tlabels);
%         for(i=1:length(T))
%             if(T(i)>SRO && Tlabels(i)==1) % only consider positive labels with thresholds > SRO
%                 err = getErr(T(i), T, Tlabels);
%                 if(err<minerr)
%                     minerr = err;
%                     h = T(i);
%                 end
%             end
%         end
        tmp = find(Tlabels==target);
        for i = 1:length(tmp)
           t = dataT(tmp(i),:);
           t = [1, t];
           l = Tlabels(tmp(i));
           if l == target
              l = 1;
           else
              l = 0;
           end
           h = h + 0.05 * (l - t * h') * t;
        end
    elseif(length(find(Tlabels==1))==0) % T doesnt have positive examples, S does
%         h = min(S(find(Slabels==1))); %left-most point in S labeled 1
%         if(isconsistent(S,Slabels,h)==1) % only keep models that are consistent
%             flag = 0;
%         end
        tmp = find(Slabels==target);
        for i = 1:length(tmp) 
           t = dataS(tmp(i),:);
           t = [1, t];
           l = Slabels(tmp(i));
           if l == target
              l = 1;
           else
              l = 0;
           end
           temp_value = l - t * h';
           h = h + 0.05 * (temp_value) * t;
        end        
        
        if(isconsistent(dataS,Slabels, h,target)==1) % only keep models that are consistent
            flag = 0;
        end
    else % both have positive elements
        for i = 1:rowS
           t = dataS(i,:);
           t = [1, t];
           l = Slabels(i);
           if l == target
              l = 1;
           else
              l = 0;
           end
           h = h + 0.05 * (l - t * h') * t;
        end
        if(isconsistent(dataS,Slabels, h,target)==1) % only keep models that are consistent
            flag = 0;
        else
            return
        end 
        
        for i = 1:rowT
           t = dataT(i,:);
           t = [1, t];
           l = Tlabels(i);
           if l == target
              l = 1;
           else
              l = 0;
           end
           h = h + 0.05 * (l - t * h') * t;
        end      
        
        %--------0--------SR0----?-----SL1------------1------------------------
%         SR0 = max(S(find(Slabels==0))); % threshold must be > SRO
%         if(length(SR0)==0) % S doesn't have negative examples
%             SR0=0;
%         end
%         SL1 = min(S(find(Slabels==1))); % threshold must be <= SL1
%         if(isconsistent(S,Slabels,SL1)==1) %
%             h = SL1;
%             flag = 0;
%         else % inconsistent model
%             return
%         end
%         minerr = getErr(SL1, T, Tlabels);
%         for(i=1:length(T))
%             if(T(i)>SR0 && T(i)<=SL1 && Tlabels(i)==1) % only consider positive labels with thresholds > SRO
%                 if(isconsistent(S,Slabels,T(i))==1)
%                     err = getErr(T(i), T, Tlabels);
%                     if(err<minerr)
%                         minerr = err;
%                         h = T(i);
%                     end
%                 end
%             end
%         end
    end
    return
end
end
