%Takes the filename the Experimental Condition and the trial
%Returns the vectors that contains the frames for each gait cycle
function [framesR,framesL]=findFrame(filename,ExperimentalCondition,trial)
[num,txt,~] =xlsread(filename,'FramesZeni');
txtSz=size(txt); %All cells containting text

%Row where frames data start
rowStart=4;

%Find column corresponding to that Experimental condition
for r=1:txtSz(1)
    for c=1:txtSz(2)
        if strcmp(ExperimentalCondition,txt(r,c))==1
            colStart=c;
            break;
        end
    end
end
colEnd=colStart+1;

%Find last row that contains data
row=rowStart;

while isnan(num(row,colStart))==0 
        row=row+1;
end

rowEnd=row-1;

switch trial
    case 1
        frames=num(rowStart:rowEnd,colStart:colEnd); 
    case 2
        frames=num((rowStart:rowEnd)+9,colStart:colEnd); 
    case 3
        frames=num((rowStart:rowEnd)+18,colStart:colEnd);      
end    

framesR=frames(:,1);
framesL=frames(:,2);


%Remove NaN values when the frames matrix has different size of col1
%(framesR) and col 2 (framesL)
if isempty(find(isnan(frames), 1))==0
    [row,col]=find(isnan(frames));
%     
%     NaNcol1=length(find(col==1));
%     NaNcol2=length(find(col==2));
    
    
    for c=1:length(col)
        switch col(c)
            case 1
                framesR=frames(1:row-1,1);
            case 2
                framesL=frames(1:row-1,2);
        end
    end

end
    

end
