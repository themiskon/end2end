%plot Light - mixing rate for generalists
p = setupGeneric([]);
p = parametersChemostat(p);
p.tEnd = 2000;

for i=1:11
    for j=1:10
p.d = 0.01*i;
p.L=10*j;
setHTL(0.1, 1/500^1.5, false, false);
sim = simulateChemostat(p, p.L);
res.B(i,j,:)=mean(sim.B(floor(length(sim.t)/2/2):end,:));
    end
end
%%
%plots
figure()
t=tiledlayout(2,5);
for i=1:10
h(i)=nexttile(t);
surface(0.01:0.01:0.11,10:10:100,res.B(:,:,i)')
shading interp
axis tight
clim([0 25])
if i<6
    grid on;
set(gca,'xticklabel',{[]})  
end
if i==1 || i==6
else
    grid on;
set(gca,'yticklabel',{[]})
end
end
xlabel(t,'mixing rate (d^{-1})','fontsize',16)
ylabel(t,'light (μΕ  s^{-1} m^{-2})','fontsize',16)
cbh = colorbar(h(end)); 
% To position the colorbar as a global colorbar representing
% all tiles, 
cbh.Layout.Tile = 'east'; 
set(h,'fontsize',16)
set(gca, 'fontsize',16)
%%
figure()
for i=1:11
for j=1:10
res.c(i,j,:)=sum(res.B(i,j,:));
end
end
%overall
surface(0.01:0.01:0.11,10:10:100,res.c')
axis("tight")
shading interp
set(gca,'fontsize',16)
xlabel('mixing rate (d^{-1})','fontsize',16)
c2=colorbar;
ylabel('light (μΕ  s^{-1} m^{-2})','fontsize',16)
ylabel(c2,'Biomass (μg l^{-1})','FontSize',16,'Rotation',270)
c2.Label.Position(1) = 5;