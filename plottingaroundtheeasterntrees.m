%plotting around
if exist('warmup')
semilogy(warmup.t,warmup.u(:,p.ixStart(1):p.ixEnd(1)),'linewidth',3)
title('generalists')
xlabel('time (days)')
ylabel('biomass (μg C L^{-1})')
newcolors = {'#e6194b', '#3cb44b', '#ffe119', '#4363d8', '#f58231', '#911eb4', '#46f0f0', '#f032e6', '#bcf60c', '#fabebe'};
colororder(newcolors)
%legend could be improved
legend(num2str(p.m(p.ixStart(1))),num2str(p.m(p.ixStart(1)+1)),num2str(p.m(p.ixStart(1)+2)),num2str(p.m(p.ixStart(1)+3)),num2str(p.m(p.ixStart(1)+4)),num2str(p.m(p.ixStart(1)+5)),num2str(p.m(p.ixStart(1)+6)),num2str(p.m(p.ixStart(1)+7)),num2str(p.m(p.ixStart(1)+8)),num2str(p.m(p.ixStart(1)+9)))
end
%plot second zooplankton group
if exist('warmup')
figure()
semilogy(warmup.t,warmup.u(:,p.ixStart(3):p.ixEnd(3)),'linewidth',3)
title('Copepods 2')
xlabel('time (days)')
ylabel('biomass (μg C L^{-1})')
newcolors = {'#330000','#660000','#800000','#8B0000','#CD0000','#EE0000','#FF0000', '#FF3030','#FF3333','#FF4040'};
colororder(newcolors)
%legend could be improved
legend(num2str(p.m(p.ixStart(3))),num2str(p.m(p.ixStart(3)+1)),num2str(p.m(p.ixStart(3)+2)),num2str(p.m(p.ixStart(3)+3)),num2str(p.m(p.ixStart(3)+4)),num2str(p.m(p.ixStart(3)+5)),num2str(p.m(p.ixStart(3)+6)),num2str(p.m(p.ixStart(3)+7)),num2str(p.m(p.ixStart(3)+8)),num2str(p.m(p.ixStart(3)+9)))
end
%plot HTL over time
% if exist('zoomort')
% plot(1:day,zoomort,'linewidth',3)
% title('HTL mortality')
% xlabel('time (days)')
% ylabel('HTL mortality (day^{-1})')
% end
%plot generalists after loop
figure()
semilogy(s.t,s.u(:,p.ixStart(1):p.ixEnd(1)),'linewidth',3)
title('generalists')
xlabel('time (days)')
ylabel('biomass (μg C L^{-1})')
newcolors = {'#e6194b', '#3cb44b', '#ffe119', '#4363d8', '#f58231', '#911eb4', '#46f0f0', '#f032e6', '#bcf60c', '#fabebe'};
colororder(newcolors)
%legend could be improved
legend(num2str(p.m(p.ixStart(1))),num2str(p.m(p.ixStart(1)+1)),num2str(p.m(p.ixStart(1)+2)),num2str(p.m(p.ixStart(1)+3)),num2str(p.m(p.ixStart(1)+4)),num2str(p.m(p.ixStart(1)+5)),num2str(p.m(p.ixStart(1)+6)),num2str(p.m(p.ixStart(1)+7)),num2str(p.m(p.ixStart(1)+8)),num2str(p.m(p.ixStart(1)+9)))

%plot zooplankton 1 after loop
figure()
semilogy(s.t,s.u(:,p.ixStart(2):p.ixEnd(2)),'linewidth',3)
title('zooplankton 1')
xlabel('time (days)')
ylabel('biomass (μg C L^{-1})')
newcolors = {'#330000','#660000','#800000','#8B0000','#CD0000','#EE0000','#FF0000', '#FF3030','#FF3333','#FF4040'};
colororder(newcolors)
%legend could be improved
legend(num2str(p.m(p.ixStart(2))),num2str(p.m(p.ixStart(2)+1)),num2str(p.m(p.ixStart(2)+2)),num2str(p.m(p.ixStart(2)+3)),num2str(p.m(p.ixStart(2)+4)),num2str(p.m(p.ixStart(2)+5)),num2str(p.m(p.ixStart(2)+6)),num2str(p.m(p.ixStart(2)+7)),num2str(p.m(p.ixStart(2)+8)),num2str(p.m(p.ixStart(2)+9)))

%plot zooplankton 2 after loop
figure()
semilogy(s.t,s.u(:,p.ixStart(3):p.ixEnd(3)),'linewidth',3)
title('zooplankton 2')
xlabel('time (days)')
ylabel('biomass (μg C L^{-1})')
newcolors = {'#330000','#660000','#800000','#8B0000','#CD0000','#EE0000','#FF0000', '#FF3030','#FF3333','#FF4040'};
colororder(newcolors)
%legend could be improved
legend(num2str(p.m(p.ixStart(3))),num2str(p.m(p.ixStart(3)+1)),num2str(p.m(p.ixStart(3)+2)),num2str(p.m(p.ixStart(3)+3)),num2str(p.m(p.ixStart(3)+4)),num2str(p.m(p.ixStart(3)+5)),num2str(p.m(p.ixStart(3)+6)),num2str(p.m(p.ixStart(3)+7)),num2str(p.m(p.ixStart(3)+8)),num2str(p.m(p.ixStart(3)+9)))

%plot fish after loop
figure()
sp=sum(r.B(:,1:6),2);
mp=sum(r.B(:,7:12),2);
lp=sum(r.B(:,13:21),2);
bp=sum(r.B(:,22:30),2);
ld=sum(r.B(:,31:end),2);
plot(r.t,sp)
plot(r.t,sp,'linewidth',3)
hold on
plot(r.t,mp,'linewidth',3)
plot(r.t,lp,'linewidth',3)
plot(r.t,bp,'linewidth',3)
plot(r.t,ld,'linewidth',3)
xlabel('time (yr)')
ylabel('biomass (g_{C WW} m^{-2})')
%%
figure()
%code for each fish preference on zoo
[theta,~,~,~,~] = calcpreference(param);
i=4;
semilogx(param.wc(param.ixZoo),theta(param.ix1(i):param.ix2(i),param.ixZoo),'linewidth',3)
legend('smal1','smal2','smal3','ad1','ad2','ad3')
title('bathypelagic preference on zooplankton')
xlabel('zooplankton mass (g C WW)')
ylabel('preference')

if param.ix2(i)-param.ix1(i)>5
legend('sm1','sm2','sm3','sm4','sm5','sm6','ad1','ad2','ad3')
else
legend('sm1','sm2','sm3','ad1','ad2','ad3')
end
%%