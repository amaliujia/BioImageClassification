function label=oracle2(features)
% input: features is the feature vector returned by nextImage
% output: label is the true label (1= Endosomes; 2=Lysosomes; 3=Mitochondria; 4=Peroxisomes; 5=Actin; 6=Plasma Membrane; 7=Microtubules; and 8=Endoplasmic Reticulum
[data,txt]=xlsread('pool.csv');
m = load('trueLabels.mat');m=m.trueLabels;
for(n=1:5120)
    if(sum(abs(data(n,:)-features))==0)
        label=m(n);
        return
    end
end
error('unknown image');
end