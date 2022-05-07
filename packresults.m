function s = packresults(st, per)
%merges multiple structures into one, up to 3 levels
%input
% str : structure that containts structures
% per : percentage of the data kept
arguments
 st struct = []
 per double = 100
end

%initial step
daycount=(fieldnames(st));
Init=length(daycount);
keep=floor(Init*(per/100));

%%loop that removes fields
for ever =1:Init-keep
st=rmfield(st,(daycount{ever}));
end

s=st.(daycount{Init-keep+1});
fns=fieldnames(st.(daycount{Init-keep+1}));

%extract structured data
for ii = Init-keep+2:Init
    for i= 1: length(fns)
        if isstruct(st.(daycount{ii}).(fns{i}))
            newlevel=fieldnames(st.(daycount{ii}).(fns{i}));
            for j=1:length(newlevel)
                if isstruct(st.(daycount{ii}).(fns{i}).(newlevel{j}))
                    nlevel=fieldnames(st.(daycount{ii}).(fns{i}).(newlevel{j}));
                    for k=1:length(nlevel)
                        s.(fns{i}).(newlevel{j}).(nlevel{k})=[s.(fns{i}).(newlevel{j}).(nlevel{k}); st.(daycount{ii}).(fns{i}).(newlevel{j}).(nlevel{k})];
                    end
                else
                    s.(fns{i}).(newlevel{j})=[s.(fns{i}).(newlevel{j}); st.(daycount{ii}).(fns{i}).(newlevel{j})];
                end
            end
        else
            s.(fns{i})=[s.(fns{i}); st.(daycount{ii}).(fns{i})];
        end
    end
end

%replace duplicate fields %%

if isfield(s,'t')
    clear s.t
    s.t=st.(daycount{Init-keep+1}).t;
    for i= Init-keep+2:Init
        s.t=[s.t; (s.t(end)+st.(daycount{i}).t)];
    end
end

if isfield(s,'T')
    clear s.T
    s.T=st.(daycount{Init-keep+1}).T;
end

if isfield(s,'L')
    clear s.L
    s.L=st.(daycount{Init-keep+1}).L;
end

if isfield(s,'p')
    clear s.p
    s.p=st.(daycount{Init-keep+1}).p;
end

end