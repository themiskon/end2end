function [sim,result,zoomort]=simulateendtoend(p,param,Endtime,warmup)
zoomort=zeros(p.InitEnd,length(param.ixZoo));
disp('running the loop simulation')
tic
for day=1:Endtime
    %for the first day the simulation uses the last time step results from
    %the warmup simulation. For step >1 it uses the last time step results
    if day>1
        p=sim.(sprintf('day%d',day-1)).p;
        p.u0= sim.(sprintf('day%d',day-1)).u(end,:);
    else
        if isfield(p, 'onceagainnum')
            p.u0=p.onceagainnum;    
        else
            p.u0=warmup.u(end,:);
        end
    end
    %1 step at the time for each model    
    sim.(sprintf('day%d',day))= simulateChemostat(p, p.L);

    if day>1
        param.B0 = result.(sprintf('day%d',day-1)).B(end,:);
        param.newK(1:2) = result.(sprintf('day%d',day-1)).R(end,end-1:end);
        param.y0 = [sim.(sprintf('day%d',day)).u(end,sim.(sprintf('day%d',day)).p.ixStart(2):end).*param.NtF param.newK result.(sprintf('day%d',day-1)).B(end,:)];
    else
        if isfield(param, 'onceagainfeisty')
            param.B0=param.onceagainfeisty(param.ixFish);
            Bent=param.onceagainfeisty(param.ixBent);
            param.y0 = [sim.(sprintf('day%d',day)).u(end,sim.(sprintf('day%d',day)).p.ixStart(2):end).*param.NtF Bent param.B0];
        else            
            param.B0 = 0*param.ixFish+.01;
            param.y0 = [sim.(sprintf('day%d',day)).u(end,sim.(sprintf('day%d',day)).p.ixStart(2):end).*param.NtF param.K(3:end) param.B0];
             %remove fish groups
              %if(param.bottom <= param.mesop)
                 param.y0(param.ix1(2):param.ix2(2))=0; %mesopelagics to zero
                 param.y0(param.ix1(4):param.ix2(4))=0; %mid-water pred to zero
                 param.y0(param.ix1(3):param.ix2(3))=0; %large pelagics to zero
                 param.y0(param.ix1(5):param.ix2(5))=0; %demersals to zero
             %end
        end
        
    end
    
    result.(sprintf('day%d',day))= poem(param);
    zoomort(day,:)=calcmort(sim.(sprintf('day%d',day)), result.(sprintf('day%d',day)), param);
end
toc