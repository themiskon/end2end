function zoomort = calcmort(sim ,result, param)
%set neccessary parameters
% beta=500;
% sigma=1.5;
if isstruct(sim)
    y=[(sim.u( end, sim.p.ixStart(2):sim.p.ixEnd(end)).*param.proddepth./100)';...
    result.R(end,param.ixBent)';...
   result.B(end,:)'];
else
    y=[sim(13:end)'.*param.proddepth./100;...
       result(param.ixBent)';...
       result(param.ixFish)'];
end
[~, mortpred, ~] = calcEncounter(y, param);
zoomort=mortpred(param.ixZoo);
%create an array with zero values for unicellulars
phyto=zeros(1,10);
%combine mortality values for all NUM spectrum
mortHTL=[phyto,mortpred(param.ixZoo)./365.25]; %transform rate from per year to per day
dummy=mortHTL(param.p.ixStart(2)-param.p.idxB+1:end);
dummy(dummy<0.005)=0.005;
mortHTL(param.p.ixStart(2)-param.p.idxB+1:end)=dummy;
%disable quadratic
setHTL(0,0,false,false);
%call new mortality
calllib(loadNUMmodelLibrary(), 'f_setmorthtl', ...
    double(mortHTL) );
%%%%%%%%%%  MUSEUM OF OLD CODE   ###########
% mass=sim.p.m(sim.p.ixStart(2):end);
% 
% pHTL=exp(-(log(mass*beta./(mortm*beta)).^2)./(2*sigma^2));
% pHTL(mass>mortm)=1;
% Bzoo=pHTL.*sim.u(end, sim.p.ixStart(2):sim.p.ixEnd(end)).*param.proddepth./100;
% B=sim.u(end, sim.p.ixStart(2):sim.p.ixEnd(end)).*param.proddepth./100;
% Czoo=mortpred(param.ixZoo).*sim.u(end, sim.p.ixStart(2):sim.p.ixEnd(end));

%m= (sum(Czoo)/sum(Bzoo))/365.25; %transform mortality per day

end