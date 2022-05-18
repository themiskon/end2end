%end to end *alpha version*
%model is now independent of number of zooplankton size classes
%mass balance
%HTL mortality transfer to NUM
%Allocation to growth changed in FEISTY
%fishing (coming soon)

%add path to feisty folder, 
addpath('/zhome/2a/3/160177/MATLAB/Projects/FEISTY/Simple_run')

%choose parameters:
mAdult=[0.2,1,3.5,14,60,250,1000]; %set number of zooplankton groups and max sizes
L=100; %set light conditions
pudeep=50; %set deep nutrients
d=0.1; %set mixing rate
 %in case there is a previous simulation
if exist('onceagain')
else
onceagain=[];
end

[p,param]=parametersendtoend(mAdult,L,pudeep,d,onceagain);
%% warmup - here we can have the NUM model converged before the loop simulation begins
p.tEnd=1000; %days
%Run the NUM chemostat model, returns a structure named warmup
if exist('onceagain')==0
    disp('warmup')
    warmup=simulateChemostat(p, p.L);
else
    warmup=[];
end

%% Setup and run the linked model
%setup Feisty parameters
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
plotSimulation(s)
plotPoemf(param, r)
plotdiet(param,r)
%setup and loop once again, repeat as long as needed for steady state
onceagain.onceagainnum=s.u(end,:);
onceagain.onceagainfeisty=r.y(end,:);
save 7zoo100L01d.mat onceagain
clear sim result r s
endtoend