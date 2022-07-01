
p = setupGeneric(logspace(log10(20),log10(1000),2));
p = parametersChemostat(p);
p.tEnd = 2000;

for i=1:11
    for j=1:10
p.d = 0.01*i;
p.L=10*j;
setHTL(0.1, 1, true, true);
sim = simulateChemostat(p, p.L);
rescop.B(i,j,:)=mean(sim.B(floor(length(sim.t)/2/2):end,:));
clear sim
    end
end
%% graphs

for i=1:11
for j=1:10
rescop.cop1(i,j,:)=sum(rescop.B(i,j,p.ixStart(2)-p.idxB+1:p.ixEnd(2)-p.idxB+1));
rescop.cop2(i,j,:)=sum(rescop.B(i,j,p.ixStart(3)-p.idxB+1:p.ixEnd(3)-p.idxB+1));
end
end
%overall
til=tiledlayout(2,1);
nexttile
surface(0.01:0.01:0.11,10:10:100,rescop.cop1')
title('copepod 20μg')
axis("tight")
shading interp
set(gca,'fontsize',16)
xlabel('mixing rate (d^{-1})','fontsize',16)
c2=colorbar;
ylabel('light (μΕ  s^{-1} m^{-2})','fontsize',16)
ylabel(c2,'Biomass (μg l^{-1})','FontSize',16,'Rotation',270)
c2.Label.Position(1) = 5;

nexttile
surface(0.01:0.01:0.11,10:10:100,rescop.cop2')
title('copepod 1000μg')
axis("tight")
shading interp
set(gca,'fontsize',16)
xlabel('mixing rate (d^{-1})','fontsize',16)
c2=colorbar;
ylabel('light (μΕ  s^{-1} m^{-2})','fontsize',16)
ylabel(c2,'Biomass (μg l^{-1})','FontSize',16,'Rotation',270)
c2.Label.Position(1) = 5;