numRuns = 1;
numSimulations = 1;

edfViolationHistory = zeros(numRuns + 1,1);
stamViolationHistory = zeros(numRuns + 1, 1);
for j = 1 : numRuns
seed = j + 1;

rand('seed', seed);       % initialize rand to known seed
randn('seed', seed);      % initialize randn to known seed
clear functions;        % clear persistent values in functions

% create taskSet Table
% column 1 is energy consumed per time unit, column 2 task duration
taskList = generateTaskList(4);

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
stamSchedule = scheduleEDF(stamTasks, simEnd);

% keep track of the number of violations that have occurred in a
% simulation.
numViolations = 0;
stamViolations = 0;
seed = rand();
rand('seed', seed);       % initialize rand to known seed
randn('seed', seed);      % initialize randn to known seed
for i = 1 : numSimulations
    % simulate the calculated schedule
    [v, lastBatteryHistory] = simulate(taskList, scheduleTable, simEnd, batteryLevel, idleEnergy);
    numViolations = numViolations + v;
end
rand('seed', seed);       % initialize rand to known seed
randn('seed', seed);      % initialize randn to known seed
for i = 1 : numSimulations
    [v, lastBatteryHistory] = simulate(stamTasks, stamSchedule, simEnd, batteryLevel, idleEnergy);
    stamViolations = stamViolations + v;
end
%numViolations
%stamViolations
edfViolationHistory(j) = numViolations;
stamViolationHistory(j) = stamViolations;

plotSimulation(taskList, scheduleTable, stamTasks, stamSchedule, lastBatteryHistory);
end