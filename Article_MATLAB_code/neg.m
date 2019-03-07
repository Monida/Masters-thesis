function NegNormGaitData=neg(NormGaitData)
neg=repmat([-1 1 1],100,1);
trialCount=3;
% NegNormGaitData=zeros(size(NormGaitData,1),size(NormGaitData,2),size(NormGaitData,3));
for t=1:trialCount
    gaitCycleCount=size(NormGaitData{t},2);
    for gc=1:gaitCycleCount
        NegNormGaitData{t}{gc}=NormGaitData{t}{gc}.*neg;
    end
end

end
