%end to end
%setup the adult sizes for copepods
%model is now independent of number of zooplankton size classes
mAdult=[20 1000];
%add path to feisty folder
addpath('/zhome/2a/3/160177/MATLAB/Projects/FEISTY/Simple_run')

%warmup
p = setupGeneric(mAdult);
p = parametersChemostat(p);
p.ud = 50; %boundary concentration
p.L = 100;
p.tEnd=1000;
disp('warmup')
[warmup]=simulateChemostatInit(p, p.L);
tic
disp('running the loop simulation')
for day=1:350
    if day>1
        p.u0= sim.(sprintf('day%d',day-1)).u(end,:);
    else
        p.u0=warmup.u(end,:);
    end
    p.tEnd=1;
    %%Change parameters
    p.L=  100 ;  %light
    %p.d=     %turbulence
    [sim.(sprintf('day%d',day))]= simulateChemostat(p, p.L);
end
toc

%assemble the results
disp('packing the results')
s=packresults(sim);

%plot general trends
disp('plotting')
plotSimulation(s);