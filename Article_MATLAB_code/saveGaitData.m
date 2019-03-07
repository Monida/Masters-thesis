%save matlab variables to a folder
% folderName=uigetdir;
folderName=strcat('C:\Users\Monica Daniela\Desktop\Matlab code test','\');
fileName=input('Type the file name','s');
fileName=strcat(fileName,'.mat');
PathAndFileName=strcat(folderName,fileName);
save (PathAndFileName);
