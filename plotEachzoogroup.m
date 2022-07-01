function plotEachzoogroup(sim)

figure()
plot(sim.t, sim.u(:, sim.p.ixStart(2):sim.p.ixEnd(2)))