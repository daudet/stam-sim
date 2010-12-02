%rand('seed', 0);       % initialize rand to known seed
%randn('seed', 0);      % initialize randn to known seed
clear functions;        % clear persistent values in functions

% create taskSet Table
% column 1 is energy consumed per time unit, column 2 task duration
taskList = generateTaskSet(4);

% set some value for idle task energy demand
idleEnergy = 0.1;

% set initial battery level
batteryLevel = 12;

% end time for simulation
simEnd = 100;

% static schedule table
% column 1 is start time, column 2 task number
scheduleTable = scheduleEDF(taskList, simEnd);

%create STAM task set and create schedule table
stamTasks = createSTAM(taskList);
stamTable = scheduleEDF(stamTasks, simEnd);

% keep track of the number of violations that have occurred in a
% simulation.
numViolations = 0;

for i = 1 : 1
% simulate the calculated schedule
[v, lastBatteryHistory] = simulate(taskList, scheduleTable, simEnd, batteryLevel, idleEnergy);
numViolations = numViolations + v;
end
numViolations


plotSimulation(taskList, scheduleTable, stamTasks, stamTable, lastBatteryHistory);