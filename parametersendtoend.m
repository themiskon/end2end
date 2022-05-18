%setup of parameters for the end to end simulation
%in:
%mAdult: vector, maximum multicellular organism size, the model creates as
%many groups as the length of the vector, default two groups with maximum
%size 20 and 1000 μg respectively
%L: Light, default 100 mmol PAR m^-2
%udeep: deep layer nutrient concentration, default: 50μg l^-1
%d : mixing rate, default: 0.1 d^-1
%onceagain: previous simulation values

function [p,param]=parametersendtoend(mAdult,L,pudeep,d,onceagain)

arguments
mAdult double =[20 1000];
L double = 100;
pudeep double = 50;
d double = 0.1;
onceagain struct =[]
end

%add path to FEISTY folder
addpath('/zhome/2a/3/160177/MATLAB/Projects/FEISTY/Simple_run')
p = setupGeneric(mAdult);
p = parametersChemostat(p);
p.L = L; %Light
p.udeep=pudeep; %deep N concentration
p.d=d; %mixing rate d^-1
baseparameters
% μg/l to g WW/m^2
% μg/l 1000 l/m^3 
param.proddepth=20; %________________________%%%% meters
param.p=p;
%add benthos parameters
bent = 150;
BeR = 0.1*(bent*(param.bottom/param.photic)^-0.86);
BeR(BeR>=(bent*0.1)) = bent*0.1;
param.K =  [80    80    BeR    0];  % g C ww/m2
if isfield(onceagain,'onceagainnum')
    p.onceagainnum=onceagain.onceagainnum;
end
if isfield(onceagain, 'onceagainfeisty')
    param.onceagainfeisty=onceagain.onceagainfeisty;
end
param.proddepth=20; %________________________%%%% meters
param.muTg=1/1000000; %μg to g
param.lTm=1000; %liters to cubic meters
param.dTw=10; %dry to wet C weight
param.NtF=param.muTg*param.lTm*param.dTw*param.proddepth;

end


