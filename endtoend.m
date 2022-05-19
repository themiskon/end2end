%end to end *alpha version*
%model is now independent of number of zooplankton size classes
%mass balance
%HTL mortality transfer to NUM
%Allocation to growth changed in FEISTY
%fishing (coming soon)

%add path to feisty folder, 
addpath('/Simple_run')

%choose parameters:
mAdult=[0.2,2,20,200,1000,1250]; %set number of zooplankton groups and max sizes
L=100; %set light conditions
pudeep=50; %set deep nutrients
d=0.1; %set mixing rate
 %in case there is a previous simulation
if exist('onceagain')
    if isstruct(onceagain)
    else
       onceagain=[]; 
    end
else
onceagain=[];
end

[p,param]=parametersendtoend(mAdult,L,pudeep,d,onceagain);
%% warmup - here we can have the NUM model converged before the loop simulation begins
p.tEnd=1000; %days
%Run the NUM chemostat model, returns a structure named warmup
if ~isstruct(onceagain)
    disp('warmup')
    warmup=simulateChemostat(p, p.L);
else
    warmup=[];
end

%% Run the linked model
p.InitEnd=5000; %____________________________________%%%%% Days
p.tEnd=1;
[sim,result,zoomort]=simulateendtoend(p,param,p.InitEnd,warmup);

disp('packing results')
tic
s=packresults(sim);
r=packresults(result);
toc
disp('plotting')
p.tEnd=p.InitEnd;
s.p.tEnd=p.InitEnd;
plotSimulation(s)
plotPoemf(param, r)
plotdiet(param,r)
%setup and loop once again, repeat as long as needed for steady state
onceagain.onceagainnum=s.u(end,:);
onceagain.onceagainfeisty=r.y(end,:);
save 7zoo100L01d.mat onceagain
clear sim result r s
endtoend
