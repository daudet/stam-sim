numRuns = 1;
numEdfSimulations = 1;
numLsaSimulations = 0;
numEdfStamSimulations = 1;
numLsaStamSimulations = 0;

edfViolationHistory = zeros(numRuns + 1,1);
edfStamViolationHistory = zeros(numRuns + 1, 1);
lsaViolationHistory = zeros(numRuns + 1,1);
lsaStamViolationHistory = zeros(numRuns + 1, 1);
for j = 1 : numRuns
seed = j + 2009;

rand('seed', seed);       % initialize rand to known seed
randn('seed', seed);      % initialize randn to known seed
clear functions;        % clear persistent values in functions


% set some value for idle task energy demand
idleEnergy = 0.05;

% set initial battery level
batteryLevel = 12;

% end time for simulation
simEnd = 100;

% create real task list and schedule the real tasks
[taskList, stamTasks] = generateTaskList(4);
edfSchedule = scheduleEDF(taskList, simEnd);
lsaSchedule = scheduleLSA(taskList, simEnd);

%create STAM task list and create schedule the virtual tasks
edfStamSchedule = scheduleEDF(stamTasks, simEnd);%convertSTAM(taskList, stamTasks, scheduleEDF(stamTasks, simEnd));
lsaStamSchedule = convertSTAM(taskList, stamTasks, scheduleLSA(stamTasks, simEnd));

% keep track of the number of violations that have occurred in a
% simulation.
edfViolations = 0;
lsaViolations = 0;
edfStamViolations = 0;
lsaStamViolations = 0;

% seed each simulation with the next random number
seed = rand();

%%%%% Run EDF simulation
rand('seed', seed);       % initialize rand to known seed
randn('seed', seed);      % initialize randn to known seed
for i = 1 : numEdfSimulations
    % simulate the calculated schedule
    [v, lastBatteryHistory] = simulate(taskList, edfSchedule, simEnd, batteryLevel, idleEnergy);
    edfViolations = edfViolations + v;
end

%%%%% Run LSA simulation
rand('seed', seed);       % initialize rand to known seed
randn('seed', seed);      % initialize randn to known seed
for i = 1 : numLsaSimulations
    % simulate the calculated schedule
    [v, lastBatteryHistory] = simulate(taskList, lsaSchedule, simEnd, batteryLevel, idleEnergy);
    lsaViolations = lsaViolations + v;
end

%%%%% Run EDF STAM simulation
rand('seed', seed);       % initialize rand to known seed
randn('seed', seed);      % initialize randn to known seed
for i = 1 : numEdfStamSimulations
    [v, lastBatteryHistory] = simulate(taskList, edfStamSchedule, simEnd, batteryLevel, idleEnergy);
    edfStamViolations = edfStamViolations + v;
end

%%%%% Run LSA STAM simulation
rand('seed', seed);       % initialize rand to known seed
randn('seed', seed);      % initialize randn to known seed
for i = 1 : numLsaStamSimulations
    [v, lastBatteryHistory] = simulate(taskList, lsaStamSchedule, simEnd, batteryLevel, idleEnergy);
    lsaStamViolations = lsaStamViolations + v;
end
%numViolations
%stamViolations
edfViolationHistory(j) = edfViolations;
edfStamViolationHistory(j) = edfStamViolations;
lsaViolationHistory(j) = lsaViolations;
lsaStamViolationHistory(j) = lsaStamViolations;

plotSimulation(taskList, edfSchedule, stamTasks, edfStamSchedule, lastBatteryHistory);
end