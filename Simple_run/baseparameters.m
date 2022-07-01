clearvars param y
param.tEnd =  1/365.25;
%
% Resources:
%define indices for resources:

param.ixZoo=1:length(p.u0(p.ixStart(2):p.ixEnd(end))); %the 2 can be replaced by p.ixStart(p.idxZ)
for i=1:length(mAdult)
param.(sprintf('ixZoo%d',i))(1:p.typeGroups(i+1))=param.ixZoo((i-1)*p.typeGroups(i+1)...
    +1:param.ixZoo((i-1)*p.typeGroups(1+i)+p.typeGroups(1+i))); 
end
param.ixBent=[length(param.ixZoo)+1:length(param.ixZoo)+2];
param.ixR = [param.ixZoo param.ixBent];

%add sizes in Feisty model (*10 to transform them into WW and /1000000 to
%transform μg to g)
param.w(param.ixR) = [p.mLower(p.ixStart(2):p.ixEnd(end))./100000 0.5e-03 0.25]; % lower limit
param.wc(param.ixR) = [p.m(p.ixStart(2):p.ixEnd(end))./100000 0.5e-03*sqrt(250000) 0.25*sqrt(500)]; % central size
param.wu(param.ixR) = [p.mUpper(p.ixStart(2):p.ixEnd(end))./100000  125  125]; % upper limit
param.r =  [param.w.*0+1  1  0];  % g ww/m2/yr
param.K =  [5  5  5  0];  % g ww/m2
%
% stages
%   
param.nstage = 6; % number of stages predator use 3, 6, 9, etc (prey = 2/3)
param.nsize  = param.nstage + 1; % 
param.sfish = 0.001; % smallest size fish (all fish)
param.lfish = 125000; % largest size fish (only predator)
param.smat = 0.5; % weight at maturity forage/meso
param.lmat = 250; % weight at maturity predators
param.sizes = logspace(log10(param.sfish), log10(param.lfish),param.nsize);
[nb,param.maxsmall] = min(abs(param.sizes-180));
param.stage = param.sizes(end)/param.sizes(end-1);

%
% Species:
%
param.nSpecies = 5;
param.ixFish =max(param.ixR)+1: max(param.ixR)+(param.nstage*2/3)*2+(param.nstage)*3; % Index for all fish
%
%
% Indices and weight classes small pelagics
param.w = [param.w param.sizes(1:param.maxsmall-1)];
param.ix1(1) = max(param.ixR)+1;
param.ix2(1) = max(param.ixR)+(param.maxsmall-1);
% Indices and weight classes mesopelagics:
param.w = [param.w param.sizes(1:param.maxsmall-1)];
param.ix1(2) = param.ix2(1) + 1; 
param.ix2(2) = param.ix2(1) + (param.maxsmall-1);
% Indices and weight classes large pelagic:
param.w = [param.w param.sizes(1:end-1)];
param.ix1(3) = param.ix2(2) + 1; 
param.ix2(3) = param.ix2(2) + (param.nsize-1);
% Indices and weight classes bathypelagic:
param.w = [param.w param.sizes(1:end-1)];
param.ix1(4) = param.ix2(3) + 1; 
param.ix2(4) = param.ix2(3) + (param.nsize-1);
% Indices and weight classes large demersal:
param.w = [param.w param.sizes(1:end-1)];
param.ix1(5) = param.ix2(4) + 1; 
param.ix2(5) = param.ix2(4) + (param.nsize-1);

param.wc(param.ixFish) = param.w(param.ixFish)*sqrt(param.stage); % central sizes
param.wu(param.ixFish) = param.w(param.ixFish)*param.stage; % Upper sizes

% predator prey preference
param.beta = 500; 
param.sigma = 1.3;
%
% Initial conditions 

%param.B0(param.ix1(1)-4:param.ix2(1)-4)=0; %put small pelagics to zero
% param.B0(param.ix1(2)-4:param.ix2(2)-4)=0; %put small mesopelagics to zero
% param.B0(param.ix1(3)-4:param.ix2(3)-4)=0; %put large pelagics to zero
% param.B0(param.ix1(4)-4:param.ix2(4)-4)=0; %put bathypelagics to zero
%param.B0(param.ix1(5)-4:param.ix2(5)-4)=0; %put large demersals to zero

%
% Habitat and interactions
%
param.bottom = 200; % depth in meter
param.photic = 150;
param.mesop = 250;
param.visual = 1.5; % scalar; >1 visual predation primarily during the day, = 1 equal day and night
[param.theta, param.depthDay, param.depthNight, param.avlocDay, param.avlocNight] = calcpreference(param); % feeding preference matrix 

%
% Calculate temperature dependency 
%
param.Q10 = 1.88;
param.Q10m =  1.88;
param.region = 2; % 1=tropical, 2=temperate, 3=boreal, 4 = no temp scaling
[param.scTemp, param.scTempm] = calctemperature(param);

%
% Physiology:
%
param.h = 20; 
param.met = 0.2*param.h; % maintenance costs, 20% of param.h
param.epsAssim = 0.7;
param.q = 0.8;
param.n = 0.75;
param.m = 0.825;    
param.F = 0*param.ixFish';  % Fishing mortality
param.gamma = 70; % factor for the max clearance rate (area per time) 
param.eRepro = repmat(0.01,param.nSpecies,1)';
param.mort0 = 0*param.ixFish'+.1; 

% define investment in maturation
[~,param.matstageS] = min(abs(param.sizes-param.smat));
[~,param.matstageL] = min(abs(param.sizes-param.lmat));
param.kappaS = [ones(param.matstageS-1,1)' repmat(0.5,(param.maxsmall-1-(param.matstageS-1)),1)'];
param.kappaL = [ones(param.matstageL-1,1)' repmat(0.5,(param.nsize-1-(param.matstageL-1)),1)'];
param.kappa = [param.kappaS param.kappaS param.kappaL param.kappaL param.kappaL];
% param.allogrS=1-((1+(param.wc(param.ix1(1):param.ix2(1))./param.smat).^(-5)).^(-1).*(param.wc(param.ix1(1):param.ix2(1))./param.lmat).^(1-param.n));
% param.allogrL=1-((1+(param.wc(param.ix1(3):param.ix2(3))./param.lmat).^(-5)).^(-1).*(param.wc(param.ix1(3):param.ix2(3))./param.lfish).^(1-param.n));
% param.kappa = [param.allogrS param.allogrS param.allogrL param.allogrL param.allogrL];

param.z = (param.w./param.wu)';
param.Cmax = (param.h*param.wc.^param.n)./param.wc .* param.scTemp;
param.V = (param.gamma*param.wc.^param.q)./param.wc .* param.scTemp;
param.Mc = (param.met*param.wc.^param.m)./param.wc .* param.scTempm;