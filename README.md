# End to End (E2E) supplementary code
Technical University of Denmark - National Institute of Aquatic Resources                    DTU Aqua
This code is part of the special course: End to end ecosystem modelling, supervised by Ken H Andersen.

Although the knowledge of natural sciences and the computational power is increasing, earth is too complex to be simulated by a modern computer. Contemporary solutions involve models limited in space or details. Spatially limited models can provide high resolution in specific ecosystems, whereas generic models describe global trends. In this work the first principles NUM and the fisheries model FEISTY were linked. 

!! coming soon: onceagain presaved structures for fast converged model results !!

Instructions:
The project should be placed in NUM model MATLAB folder, otherwise, add paths in endtoend and parametersendtoend files.
end2end.m : file that runs the simulation.
simulateendtoend : contains the loop simulation
parametersendtoend: sets up the parameters needed for the model
calcmort: transfers mortality from FEISTY to NUM, uses custom library, sets minimum HTL mortality to 0.005 day^{-1}
getfirst: returns a matrix with Biomass for all organisms during the first step of each simulated day
getlast: similar to the previous one. Returns a matrix with the biomass in the last time step of each simulated day
plotcustomHTL: function that is used to test custom HTL mortalities on NUM model
testHTLmort: works with plotcustomHTL
packresults: merges the outputs for compatibility reasons (plotting with existing functions)
folder simple_run: contains the modified FEISTY model

Coming soon:
onceagaincode: a loop specified to run multiple years for a converged model
massconservationcheck: function that checks if NUM and FEISTY numbers add up
plotEachzoogroup: plots zooplankton group biomass
plotfeedinglevel: plots feeding level for fish (can be replaced by existing functions)
plotfishbiomass: plots fish biomass over time, all of them, analytically
plotPHTL: plots different HTL selectivity curves
sizepreference: plots size preference for all species
testsim: tests if NUM model works in loop simulation environments
plottingaroundtheeasterntrees: easter egg function, provides many plots
