function s = packresults(str, per)
%merges multiple structures into one, up to 3 levels
%input:
% str : structure that containts structures
% per : percentage of the data kept 
%initial step
arguments
 str struct = []
 per double = 100
end

daycount=(fieldnames(str));
Init=length(daycount);
keep=length(daycount)-floor(length(daycount)*(1-per/100));
if Init-keep > 0
    ciao=daycount(1:Init-keep);
    str=rmfield(str,ciao);
end

s=str.(daycount{Init-keep+1});
fns=fieldnames(str.(daycount{Init-keep+1}));

%extract structured results
for ii = Init-keep+2:Init
    for i= 1: length(fns)
        if isstruct(str.(daycount{ii}).(fns{i}))
            newlevel=fieldnames(str.(daycount{ii}).(fns{i}));
            for j=1:length(newlevel)
                if isstruct(str.(daycount{ii}).(fns{i}).(newlevel{j}))
                    nlevel=fieldnames(str.(daycount{ii}).(fns{i}).(newlevel{j}));
                    for k=1:length(nlevel)
                        s.(fns{i}).(newlevel{j}).(nlevel{k})=[s.(fns{i}).(newlevel{j}).(nlevel{k}); str.(daycount{ii}).(fns{i}).(newlevel{j}).(nlevel{k})];
                    end
                else
                    s.(fns{i}).(newlevel{j})=[s.(fns{i}).(newlevel{j}); str.(daycount{ii}).(fns{i}).(newlevel{j})];
                end
            end
        else
            s.(fns{i})=[s.(fns{i}); str.(daycount{ii}).(fns{i})];
        end
    end
end

%replace duplicate fields

if isfield(s,'t')
    clear s.t
    s.t=str.(daycount{Init-keep+1}).t;
    for i= Init-keep+2:Init
        s.t=[s.t; (s.t(end)+str.(daycount{i}).t)];
    end
end

if isfield(s,'T')
    clear s.T
    s.T=str.(daycount{Init-keep+1}).T;
end

if isfield(s,'L')
    clear s.L
    s.L=str.(daycount{Init-keep+1}).L;
end

if isfield(s,'p')
    clear s.p
    s.p=str.(daycount{Init-keep+1}).p;
end

end
