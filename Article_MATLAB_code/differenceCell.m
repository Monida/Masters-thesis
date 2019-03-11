%This function returns a the difference between RSref and RS in cell format
%RSref is a Matrix that contains the values of all the frames of all gait
%cycles of a given reference experimental condition from reference recording system
%RS nonideal is a Matrix that contains the values of all the frames of all
%gait cycles of a given experimental condition from recording system to be
%compared to the reference recording system
function DiffCell=differenceCell(RSref,RS)

for i=1:3
    if size(RSref{i})<size(RS{i})
        cellSize(i)=size(RSref{i},2);
    else
        cellSize(i)=size(RS{i},2);
    end
end

    for i=1:3
        for j=1:cellSize(i)
            DiffCell{i}{j}=RSref{i}{j}-RS{i}{j};
        end
    end
end