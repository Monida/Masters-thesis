%findCMCError
DiffCellRHipVicRef=differenceCell(NormRHipVic,NormRHipRef);
DiffCellRKneeVicRef=differenceCell(NormRKneeVic,NormRKneeRef);
DiffCellRAnkleVicRef=differenceCell(NormRAnkleVic,NormRAnkleRef);
DiffCellLHipVicRef=differenceCell(NormLHipVic,NormLHipRef);
DiffCellLKneeVicRef=differenceCell(NormLKneeVic,NormLKneeRef);
DiffCellLAnkleVicRef=differenceCell(NormLAnkleVic,NormLAnkleRef);

DiffCellRHipVicCorr=differenceCell(NormRHipVic,NormRHipCorr);
DiffCellRKneeVicCorr=differenceCell(NormRKneeVic,NormRKneeCorr);
DiffCellRAnkleVicCorr=differenceCell(NormRAnkleVic,NormRAnkleCorr);
DiffCellLHipVicCorr=differenceCell(NormLHipVic,NormLHipCorr);
DiffCellLKneeVicCorr=differenceCell(NormLKneeVic,NormLKneeCorr);
DiffCellLAnkleVicCorr=differenceCell(NormLAnkleVic,NormLAnkleCorr);

DiffCellRHipVicRComp=differenceCell(NormRHipVicR,NormRHipComp);
DiffCellRKneeVicRComp=differenceCell(NormRKneeVicR,NormRKneeComp);
DiffCellRAnkleVicRComp=differenceCell(NormRAnkleVicR,NormRAnkleComp);
DiffCellLHipVicRComp=differenceCell(NormLHipVicR,NormLHipComp);
DiffCellLKneeVicRComp=differenceCell(NormLKneeVicR,NormLKneeComp);
DiffCellLAnkleVicRComp=differenceCell(NormLAnkleVicR,NormLAnkleComp);

%% Baseline error vs Postural error
CMCLHipBaseError=cmcError(DiffCellLHipVicRComp,DiffCellLHipVicRef);
CMCLKneeBaseError=cmcError(DiffCellLKneeVicRComp,DiffCellLKneeVicRef);
CMCLAnkleBaseError=cmcError(DiffCellLAnkleVicRComp,DiffCellLAnkleVicRef);
CMCRHipBaseError=cmcError(DiffCellRHipVicRComp,DiffCellRHipVicRef);
CMCRKneeBaseError=cmcError(DiffCellRKneeVicRComp,DiffCellRKneeVicRef);
CMCRAnkleBaseError=cmcError(DiffCellRAnkleVicRComp,DiffCellRAnkleVicRef);
CMCBaseError=[CMCRHipBaseError' CMCLHipBaseError'; CMCRKneeBaseError' CMCLKneeBaseError'; CMCRAnkleBaseError' CMCLAnkleBaseError'];

%% Baseline error vs OC error
%{
CMCLHipOC=cmcError(DiffCellLHipVicRComp,DiffCellLHipVicCorr);
CMCLKneeOC=cmcError(DiffCellLKneeVicRComp,DiffCellLKneeVicCorr);
CMCLAnkleOC=cmcError(DiffCellLAnkleVicRComp,DiffCellLAnkleVicCorr);
CMCRHipOC=cmcError(DiffCellRHipVicRComp,DiffCellRHipVicCorr);
CMCRKneeOC=cmcError(DiffCellRKneeVicRComp,DiffCellRKneeVicCorr);
CMCRAnkleOC=cmcError(DiffCellRAnkleVicRComp,DiffCellRAnkleVicCorr);
CMCBaseOC=[CMCRHipOC' CMCLHipOC'; CMCRKneeOC' CMCLKneeOC'; CMCRAnkleOC' CMCLAnkleOC'];
%}
%% Baseline error vs PAC error


CMCLHipPAC=cmcError(DiffCellLHipVicRComp,DiffCellLHipVicCorr);
CMCLKneePAC=cmcError(DiffCellLKneeVicRComp,DiffCellLKneeVicCorr);
CMCLAnklePAC=cmcError(DiffCellLAnkleVicRComp,DiffCellLAnkleVicCorr);
CMCRHipPAC=cmcError(DiffCellRHipVicRComp,DiffCellRHipVicCorr);
CMCRKneePAC=cmcError(DiffCellRKneeVicRComp,DiffCellRKneeVicCorr);
CMCRAnklePAC=cmcError(DiffCellRAnkleVicRComp,DiffCellRAnkleVicCorr);
CMCBasePAC=[CMCRHipPAC' CMCLHipPAC'; CMCRKneePAC' CMCLKneePAC'; CMCRAnklePAC' CMCLAnklePAC'];

saveGaitData