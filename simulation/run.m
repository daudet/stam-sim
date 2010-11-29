% create taskSet Table
% column 1 is energy consumed per time unit, column 2 task duration
taskSet = generateTaskSet(4);

% set some value for idle task energy demand
idleEnergy = 0.1;

% set initial battery level
batteryLevel = 12;

% end time for simulation
simEnd = 40;

% static schedule table
% column 1 is start time, column 2 task number
scheduleTable = scheduleEDF(taskSet, simEnd);

% keep track of the number of violations that have occurred in a
% simulation.
numViolations = 0;

for i = 1 : 1
% simulate the calculated schedule
numViolations = numViolations + simulate(taskSet, scheduleTable, simEnd, batteryLevel, idleEnergy, 0);
end
numViolations