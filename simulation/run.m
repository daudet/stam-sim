numRuns = 10;
numEdfSimulations = 10;
numLsaSimulations = 10;
numEdfStamSimulations = 10;
numLsaStamSimulations = 10;

edfViolationHistory = zeros(numRuns + 1,1);
edfStamViolationHistory = zeros(numRuns + 1, 1);
lsaViolationHistory = zeros(numRuns + 1,1);
lsaStamViolationHistory = zeros(numRuns + 1, 1);
for j = 1 : numRuns
seed = j + 7027;

rand('seed', seed);       % initialize rand to known seed
randn('seed', seed);      % initialize randn to known seed
%clear functions;        % clear persistent values in functions

% set some value for idle task energy demand
idleEnergy = 0.05;

% set initial battery level
batteryLevel = 12;

% end time for simulation
simEnd = 100;

% create real task list and schedule the real tasks
if j == 48
    j;
end
%[taskList, stamTasks] = generateTaskList(4);

%generate a task list within some utilization bound
[taskList, stamTasks] = generateTaskListBounded(4,0.4,0.5);

if numLsaSimulations > 0 || numLsaStamSimulations > 0
    %use pseudoSimulate to use energy predictive ALAP algorithm
    lsaSchedule = pseudoSimulate(taskList, scheduleALAP(taskList, simEnd), batteryLevel, idleEnergy, 0);
    
    %lsaSchedule = scheduleALAP(taskList, simEnd);
    lsaStamSchedule = pseudoSimulate(taskList, convertSTAM(taskList, stamTasks, scheduleALAP(stamTasks, simEnd)), simEnd, batteryLevel, idleEnergy);
end

edfSchedule = scheduleEDF(taskList, simEnd);

%create STAM task list and schedule the virtual tasks
edfStamSchedule = convertSTAM(taskList, stamTasks, scheduleEDF(stamTasks, simEnd));

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
    [v, lastBatteryHistory] = simulate(taskList, edfSchedule, simEnd, batteryLevel, idleEnergy, 0);
    edfViolations = edfViolations + v;
end

%%%%% Run LSA simulation
rand('seed', seed);       % initialize rand to known seed
randn('seed', seed);      % initialize randn to known seed
for i = 1 : numLsaSimulations
    % simulate the calculated schedule
    [v, lastBatteryHistory] = simulate(taskList, lsaSchedule, simEnd, batteryLevel, idleEnergy, 1);
    lsaViolations = lsaViolations + v;
end

%%%%% Run EDF STAM simulation
rand('seed', seed);       % initialize rand to known seed
randn('seed', seed);      % initialize randn to known seed
for i = 1 : numEdfStamSimulations
    [v, lastBatteryHistory] = simulate(taskList, edfStamSchedule, simEnd, batteryLevel, idleEnergy, 0);
    edfStamViolations = edfStamViolations + v;
end

%%%%% Run LSA STAM simulation
rand('seed', seed);       % initialize rand to known seed
randn('seed', seed);      % initialize randn to known seed
for i = 1 : numLsaStamSimulations
    [v, lastBatteryHistory] = simulate(taskList, lsaStamSchedule, simEnd, batteryLevel, idleEnergy, 1);
    lsaStamViolations = lsaStamViolations + v;
end
%numViolations
%stamViolations
edfViolationHistory(j) = edfViolations;
edfStamViolationHistory(j) = edfStamViolations;
lsaViolationHistory(j) = lsaViolations;
lsaStamViolationHistory(j) = lsaStamViolations;

end

plotUtilization(0.4, edfViolationHistory,edfStamViolationHistory,lsaViolationHistory,lsaStamViolationHistory);

%plotSimulation(taskList, edfSchedule, taskList, edfStamSchedule, lastBatteryHistory);