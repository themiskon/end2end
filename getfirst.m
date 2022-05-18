function r=getfirst(str)

daycount=(fieldnames(str));
if isfield(str.(daycount{1}), 'u')
    for i=1:length(daycount)
        r(i,:)=str.(daycount{i}).u(1,:);
    end

else
    for i=1:length(daycount)
        r(i,:)=str.(daycount{i}).y(1,:);
    end
end
