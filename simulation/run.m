%create taskSet Table
%column 1 energy consumed per time unit, column 2 task duration
taskSet = [1.0, 3
           1.5, 2];

%set some value for idle task energy demand
idleEnergy = 0.2;

% set initial battery level
batteryLevel = 12;

%static schedule table
%column 1 time, column 2 task#
scheduleTable = [   3,1
                    6,2
                    13,1
                    16,2];

%set endpoint for simulation
simEnd = 40;

% simulate the calculated schedule
simulate(taskSet, scheduleTable, simEnd, batteryLevel, idleEnergy);