function plotPHTL(mortm,p,param)

beta=500;
sigma=1.5;
mass=p.m(p.ixStart(2):end);
%calculate PHTL following Camila et al., 2020
pHTL=exp(-(log(mass*beta./(mortm*beta)).^2)./(2*sigma^2));
pHTL(mass>mortm)=1;

%calculate NUM PHTL following Fortran code
pHTLfort=(1./(1+(mass./mortm).^(-2)));

%calculate Zoo mort based on FEISTY code
[theta,~,~,~,~] = calcpreference(param);

semilogx(param.wc(param.ixZoo),theta(param.ix1(1):param.ix2(2),param.ixZoo))

%plot everything
tiledlayout(3,1)
nexttile
semilogx(mass, pHTL, 'k', 'linewidth',3)
%xlabel('mass μgC')
ylabel('p_{HTL}')
ylim([0 1.1])
xlim('tight')
set(gca,'fontsize',18);
hold on
plot(mass, ones(length(mass)), ':b', 'linewidth',2)
title('P_{HTL} following Camila et al.')

nexttile
semilogx(mass, pHTLfort, 'k', 'linewidth',3)
%xlabel('mass μgC')
ylabel('p_{HTL}')
ylim([0 1.1])
xlim('tight')
set(gca,'fontsize',18);
hold on
plot(mass, ones(length(mass)), ':b', 'linewidth',2)
title('P_{HTL} following NUM model')

nexttile
maxpref=max(theta);
semilogx(mass, maxpref(1:param.ix1(1)-3), '--k', 'linewidth',3)
hold on
minpref=min(theta);
semilogx(mass, minpref(1:param.ix1(1)-3), ':k', 'linewidth',3)
hold off
xlabel('mass μgC')
ylabel('p_{HTL}')
ylim([0 1.1])
xlim('tight')
set(gca,'fontsize',18);
hold on
legend('max','min','autoupdate','off')
plot(mass, ones(length(mass)), ':b', 'linewidth',2)
title('P_{HTL} following FEISTY model')