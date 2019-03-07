folderToSavePlots='C:\Users\Monica Daniela\Dropbox\Thesis\Article MATLAB code\Preliminary results\participant4\';
% plotNPoseNWVicMVN
% plotFile='NG - Left.fig';
% saveas(f,strcat(folderToSavePlots,plotFile))
% 
% plotPostureErrorsVicMVN
% plotFile='CG - Left.fig';
% saveas(f,strcat(folderToSavePlots,plotFile))


plotVicCorr
plotFile='TG - PAC2D - Left.fig';
saveas(f,strcat(folderToSavePlots,plotFile))


plotBaselineError
plotBaselineErrorBoxplots
plotFile='Baseline error - Left.fig';
saveas(f,strcat(folderToSavePlots,plotFile))


plotBaselineVsPostureError
plotBaselineVsPostureErrorBoxplots
plotFile='CG error - Left.fig';
saveas(f,strcat(folderToSavePlots,plotFile))


plotBaselineErrorVsVicCorr
plotBaselineErrorVsVicCorrBoxplots
plotFile='TG error - PAC2D - Left.fig';
saveas(f,strcat(folderToSavePlots,plotFile))
