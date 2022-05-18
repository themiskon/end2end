function r=getlast(str)

daycount=(fieldnames(str));

if isfield(str.(daycount{1}), 'u')
    for i=1:length(daycount)
        r(i,:)=str.(daycount{i}).u(end,:);
    end

else
    for i=1:length(daycount)
        r(i,:)=str.(daycount{i}).y(end,:);
    end
end


end