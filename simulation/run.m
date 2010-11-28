% create taskSet Table
% column 1 is energy consumed per time unit, column 2 task duration
taskSet = generateTaskSet(2);

% set some value for idle task energy demand
idleEnergy = 0.1;

% set initial battery level
batteryLevel = 12;

% static schedule table
% column 1 is start time, column 2 task number
scheduleTable = [   3,1
                    6,2
                    13,1
                    16,2];

% set end time for simulation (this can be calculated
simEnd = 40;

% keep track of the number of violations that have occurred in a
% simulation.
numViolations = 0;

for i = 1 : 1
% simulate the calculated schedule
numViolations = numViolations + simulate(taskSet, scheduleTable, simEnd, batteryLevel, idleEnergy, 0);
end
numViolations