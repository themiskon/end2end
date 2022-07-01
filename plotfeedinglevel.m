function plotfeedinglevel(sim,result,param,days)
for day = 1:days
f(day,:)=calcfishfeedinglevelNUM(sim.(sprintf('day%d',day)), result.(sprintf('day%d',day)), param);
end
plothelper=linspace(0,days,length(f(:,1)));
figure()
plot(plothelper,mean(f,2),'k','linewidth',3)
hold on
plot(plothelper,min(f,[],2),'--k','linewidth',3)
plot(plothelper,max(f,[],2),':k','linewidth',3)
hold off
legend('average','min','max')
xlabel('time (days)')
ylabel('feeding level')
set(gca,'fontsize',18)
axis("tight")

end

