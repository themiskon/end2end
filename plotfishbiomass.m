function plotfishbiomass(r, param)
arguments
r struct =[]
param struct =[] 
end
if isempty(r)
    disp('try "plotfishbiomass(r,param)"')
    return
end
massday=r.y;
fname=[{'small pelagic'},{'mesopelagic'},{'large pelagic'},{'bathypelagic'},{'demersal'}];

for ix=1:param.nSpecies
    figure()
    pos1=2; %number of rows
    pos2=round((param.ix2(ix)-param.ix1(ix)+1)/pos1);
    t=tiledlayout(pos1,pos2);
    for i=1:param.ix2(ix)-param.ix1(ix)+1
        nexttile
        plot(r.t,r.y(:,(param.ix1(ix)+i-1)))
    end
    title(t,fname(ix))
    xlabel(t,'time (years)')
    ylabel(t,'Biomass (g C WW m^{-2})')
end

figure()
names=({'small pelagic','mesopelagic','large pelagic','bathypelagic','large demersal'});
for i=1:param.nSpecies
subplot(5,1,i)
plot(r.t(1:end),massday(:,param.ix1(i):param.ix2(i)),'LineWidth',3)
title(names(i))
newcolors = {'#330000','#660000','#800000','#8B0000','#CD0000','#EE0000','#FF0000', '#FF3030','#FF3333','#FF4040'};
colororder(newcolors)
legend('small','larger','etc')
end

figure()
names=({'small pelagic','mesopelagic','large pelagic','bathypelagic','large demersal'});
for i=1:param.nSpecies
    hold on
    plot(r.t,sum(r.y(:,param.ix1(i):param.ix2(i)),2),'LineWidth',3)
    names=({'small pelagic','mesopelagic','large pelagic','bathypelagic','large demersal'});
    hold off
   % legend('small','larger','etc')
   xlabel('time (years)')
   ylabel('mass g WW C')
end
set(gca, "FontSize",12)
legend('small pelagic', 'epipelagic', 'large pelagic', 'bathypelagic', 'demersal')


