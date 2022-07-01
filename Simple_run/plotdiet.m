function plotdiet(param,result)

w = param.wc;
y = result.y;

Bin = floor(0.8*length(y));
yend = mean(y(Bin:end,:));
ystage = param.ixFish(end);
ysmall = param.nstage - param.nstage*1/3;
ymean=mean(y(Bin:end,:));

[f, mortpred, Eavail] = calcEncounter(y(end,:)', param);

bom=param.theta(param.ix1(1):ystage,:) .* mean(y(Bin:end,:)); 
fbom = f(param.ix1(1):ystage)' ./ sum(bom,2);
output = bom .* fbom;
zoogroups=ones(1,length(param.ixZoo));
colspec = [zoogroups 2 2 repmat(3,param.nstage*2/3,1)' ...
           repmat(4,param.nstage*2/3,1)'         ...
           repmat(5,param.nstage,1)'             ...
           repmat(6,param.nstage,1)'             ...
           repmat(7,param.nstage,1)'];
colorSet = [ 0      0.5      0;
             0.5    0.3      0;
             0      0.447    0.7410;
             0.850  0.325    0.098;
             0.929  0.694    0.125;
             0.494  0.184    0.556;
             0.466  0.674    0.188;];

figure()

small_pel = output(param.ix1(1)-param.ixR(end):param.ix2(1)-param.ixR(end),:);
small_pel = [small_pel; zeros(ysmall,ystage)];
subplot(2,3,1)
H = bar(small_pel, 'stacked');
 for i = 1:ystage
     H(i).FaceColor = colorSet(colspec(i),:);
     H(i).LineStyle = 'none';
 end
ylim([0 1])
title('\fontsize{10}Small pelagics' )
ylabel('Fraction in stomach') 
set(gca,'XTick',[])
xlabel('size-classes')
 
meso_pel = output(param.ix1(2)-param.ixR(end):param.ix2(2)-param.ixR(end),:);
meso_pel = [meso_pel; zeros(ysmall,ystage)];
subplot(2,3,2)
H = bar(meso_pel, 'stacked');
 for i = 1:ystage
     H(i).FaceColor = colorSet(colspec(i),:); 
     H(i).LineStyle = 'none';
 end
ylim([0 1])
title('\fontsize{10}Mesopelagics')
set(gca,'YTick',[])
set(gca,'XTick',[])
xlabel('size-classes')
 
large_pel = output(param.ix1(3)-param.ixR(end):param.ix2(3)-param.ixR(end),:);
subplot(2,3,3)
H = bar(large_pel, 'stacked');
 for i = 1:ystage
     H(i).FaceColor = colorSet(colspec(i),:);
     H(i).LineStyle = 'none';
 end 
ylim([0 1])
title('\fontsize{10}Large pelagics')
set(gca,'YTick',[])
set(gca,'XTick',[])
xlabel('size-classes')

bathy_pel = output(param.ix1(4)-param.ixR(end):param.ix2(4)-param.ixR(end),:);
subplot(2,3,4)
H = bar(bathy_pel, 'stacked');
 for i = 1:ystage
     H(i).FaceColor = colorSet(colspec(i),:); 
     H(i).LineStyle = 'none';
 end 
ylim([0 1])
title('\fontsize{10}Bathypelagic')
set(gca,'YTick',[])
set(gca,'XTick',[]) 
xlabel('size-classes')

demers = output(param.ix1(5)-param.ixR(end):param.ix2(5)-param.ixR(end),:);
subplot(2,3,5)
H = bar(demers, 'stacked');
 for i = 1:ystage
     H(i).FaceColor = colorSet(colspec(i),:); 
     H(i).LineStyle = 'none';
 end 
ylim([0 1])
ylabel('Fraction in stomach')
title('\fontsize{10}Large demersal')
set(gca,'XTick',[]) 
xlabel('size-classes')

% plot legend
z=param.ixZoo(end)-3;
ix=param.ix1;
nspecies=[1 length(param.ixZoo)+1 length(param.ixZoo)+3 ix(2) ix(3) ix(4) ix(5)];
legend(H(nspecies),{'Zoopl','Benthos','Spel','Mpel','Lpel','Bpel','Ldem'})