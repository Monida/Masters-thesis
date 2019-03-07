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