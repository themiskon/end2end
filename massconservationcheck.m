% % function [food,mort]=massconservationcheck(r,s,result,sim,p,param)
FEISTY=r.y; %__________g WW C m^-2
NUM=s.u; %______________μg C l^-1
thic=param.proddepth; %meters, productive thickness
LtM=1000; %liters per m^3
DtW= 10/1000000; %conversion from μg C to g WW C
NtF= thic*LtM*DtW; %NUM to FEISTY mass convertion Equation
DtY=365.25; %days per year
NUMadjusted=NUM.*NtF; %convert units in NUM results
%calculate mass balance
s.first=getfirst(sim);
s.last=getlast(sim);
NUMmortHTL=s.rates.mortHTL(:,s.p.ixStart(2)-2:s.p.ixEnd(end)-2);
FEISTYmortHTL=r.mortpred(:,param.ixZoo);
NUMinit=s.first;
NUMlast=s.last;
NUMdudt=NUMlast(:,p.ixStart(2):end)-NUMinit(:,p.ixStart(2):end);

%% plot zooplankton population in both models over time
figure()
tiledlayout(2,1)
nexttile
plot(s.t./365,NUMadjusted(:,p.ixStart(2):end),'linewidth', 2)
title('NUM results')
ylabel('g WW C m^{-2}')
xlabel('time (years)')
nexttile
plot(r.t,r.y(:,param.ixZoo),'LineWidth',2)
title('FEISTY input')
xlabel('time (years)')
ylabel('Biomass g WW C m^{-2}')

%% Mortality Similarity check
%%   Fish units, mortality from NUM
daycount=(fieldnames(sim));
NUMlosses=zeros(length(daycount),length(param.ixZoo));
NUMdiff=zeros(length(daycount),length(param.ixZoo));
for i=500:length(daycount)
    NUMlosses(i,:)=mean(sim.(daycount{i}).u(:,s.p.ixStart(2):s.p.ixEnd(end))).*(FEISTYmortHTL(i,:)./365.25).*NtF;
    NUMdiff(i,:)=NUMdudt(i,:).*(FEISTYmortHTL(i,:)./365.25).*NtF;
end
NUMlostotal=sum(NUMlosses);
NUMdudtlosses=sum(NUMdiff);
NUMfixed=NUMlosses-NUMdiff;
NUMfixsum=sum(NUMfixed);
x=sum(NUMfixsum);
xi=sum(NUMlostotal);
%% Fish units, based on feeding from FEISTY
Feistymean=zeros(length(daycount),param.ixFish(end));
Feistymort=zeros(length(daycount),param.ixZoo(end));
for i=500:length(daycount)
FEISTYcons=zeros(length(result.(daycount{i}).y(:,1)),length(result.(daycount{i}).y(1,:)));
MortFeisty=zeros(length(result.(daycount{i}).y(:,1)),length(result.(daycount{i}).y(1,param.ixZoo)));
% Consumption
    for ii = 1:length(result.(daycount{i}).y(:,1))
        Enc=zeros(length(result.(daycount{i}).y(1,:)),length(result.(daycount{i}).y(1,:)));
        for iii = 1:length(result.(daycount{i}).y(1,:))
            Enc(iii,:) = param.V(iii) .* param.theta(iii,:).*r.y(iii,:);
        end
        EncZ=Enc(:,param.ixZoo);
        Encspecies = sum(Enc');
        EncZoo=sum(EncZ');
        f = Encspecies./(param.Cmax+Encspecies);
        f(isnan(f)) = 0;
        fzoo=EncZoo./(param.Cmax+Encspecies);
        for iii= 1:length(result.(daycount{i}).y(1,:))
           mortpr(iii,:) = (param.Cmax(iii) .* param.V(iii) .* param.theta(iii,:) ./(param.Cmax(iii) + Encspecies(iii))) * result.(daycount{i}).y(ii,iii);
        end
        mortpred = sum(mortpr);
        MortFeisty(ii,:)=mortpred(param.ixZoo).*result.(daycount{i}).y(ii,param.ixZoo);
        FEISTYcons(ii,:)=fzoo.*param.Cmax.*result.(daycount{i}).y(ii,:);
    end
    Feistymean(i,:)=mean(FEISTYcons)./365.25; %1 day time step
    Feistymort(i,:)=mean(MortFeisty)./365.25; %1 day time step
    clear Enc EncZ EncSpecies EncZoo mortpred MortFeisty mortpr FEISTYcons
end

TotalFiestycons=sum(Feistymean);
y=sum(TotalFiestycons);
Totalfeistymort=sum(Feistymort);
z=sum(Totalfeistymort);