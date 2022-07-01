%add path to feisty folder, 
addpath('/zhome/2a/3/160177/MATLAB/Projects/FEISTY/Simple_run')
%similar code with endtoend but runs faster
%setup the adult sizes for copepods
mAdult=[20,500, 1000];

p = setupGeneric(mAdult);
p = parametersChemostat(p);
p.L = 100;
p.ud=50; %deep N concentration
p.InitEnd=5000; %steps in loop model
p.d=0.1;
%Setup and run the linked model
%%setup base parameters for feisty
baseparameters
% [~,depthday,~,~,~] = calcpreference(param);
% zoodepth=depthday(:,param.ixZoo);
% weighteddepth=zoodepth./max(zoodepth);
param.proddepth=20;
%add benthos parameters
bent = 150;
BeR = 0.1*(bent*(param.bottom/param.photic)^-0.86);
BeR(BeR>=(bent*0.1)) = bent*0.1;
%the following K is decorative for now - still processing the benthos
param.K =  [80    80    BeR    0];  % g C ww/m2
zoomort=zeros(p.InitEnd,length(param.ixZoo));
param.p=p;

%Initiate the loop simulation
disp('running the loop simulation')
%setup base parameters for feisty
tic
calcmort(onceagainnum, onceagainfeisty, param);
for day=1:p.InitEnd
    %for the first day the simulation uses the last time step results from
    %the previous simulation. For step >1 it uses the last time step results
    if day>1
        %Set up HTL mortality based on FEISTY result
        %use last time step results as inpu
        p.u0= sim.(sprintf('day%d',day-1)).u(end,:);
    else
        p.u0=onceagainnum;
    end
    %1 step at the time for each model
    p.tEnd = 1;
    %%
    %%scales for rates
    %p.d=     %turbulence (default 0.5)
    sim.(sprintf('day%d',day))= simulateChemostat(p, p.L);
    %%
    if day>1
        param.B0 = result.(sprintf('day%d',day-1)).B(end,:);
        param.newK(1:2) = result.(sprintf('day%d',day-1)).R(end,end-1:end);
        param.y0 = [sim.(sprintf('day%d',day)).u(end,sim.(sprintf('day%d',day)).p.ixStart(2):end).*param.proddepth./100 param.newK result.(sprintf('day%d',day-1)).B(end,:)];
    else
        param.B0 = onceagainfeisty(param.ixFish);
        param.y0 = [sim.(sprintf('day%d',day)).u(end,sim.(sprintf('day%d',day)).p.ixStart(2):end).*param.proddepth./100 param.K(3:end)*0.1 param.B0];
         if(param.bottom <= param.mesop)
        param.y0(param.ix1(2):param.ix2(2))=0; %mesopelagics to zero
        param.y0(param.ix1(4):param.ix2(4))=0; %mid-water pred to zero
         end
    end
    %if it is shallow, there are no mesopelagics
   
  
    result.(sprintf('day%d',day))= poem(param);
    zoomort(day,:)=calcmort(sim.(sprintf('day%d',day)), result.(sprintf('day%d',day)), param);

end
toc
disp('packing results')
s=packresults(sim);
tic
r=packresults(result);
toc
disp('plotting')
p.tEnd=p.InitEnd;
plotSimulation(s)
plotPoemf(param, r)

onceagainnum=s.u(end,:);
onceagainfeisty=r.y(end,:);
% plotdiet(param,r)
save fish.mat onceagainfeisty onceagainnum
clear a* b* d* m* n* p* r* s* zoomort i B*
onceagaincode