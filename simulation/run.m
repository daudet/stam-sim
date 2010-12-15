clear functions;        % clear persistent values in functions

numRuns = 1;
numEdfSimulations = 1;
numLsaSimulations = 1;
numEdfStamSimulations = 1;
numLsaStamSimulations = 1;

edfViolationHistory = zeros(numRuns + 1,1);
edfStamViolationHistory = zeros(numRuns + 1, 1);
lsaViolationHistory = zeros(numRuns + 1,1);
lsaStamViolationHistory = zeros(numRuns + 1, 1);
for j = 1 : numRuns
seed = j + 7032; %images taken with j + 7041

rand('seed', seed);       % initialize rand to known seed
randn('seed', seed);      % initialize randn to known seed

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
[taskList, stamTasks, stfuTasks] = generateTaskListBounded(4,0.4,0.5);

edfSchedule = scheduleEDF(taskList, simEnd);
edfStfuVirtualSchedule = scheduleEDF(stfuTasks, simEnd);
edfStfuPhysicalSchedule = convertSTAM(taskList, stamTasks, edfStfuVirtualSchedule);
if numLsaSimulations > 0 || numLsaStamSimulations > 0
    %use pseudoSimulate to use energy predictive ALAP algorithm
    lsaSchedule = pseudoSimulate(taskList, scheduleALAP(taskList, simEnd), batteryLevel, idleEnergy, 0);
    
    %lsaSchedule = scheduleALAP(taskList, simEnd);
    lsaStamSchedule = pseudoSimulate(taskList, convertSTAM(taskList, stamTasks, scheduleALAP(stamTasks, simEnd)), simEnd, batteryLevel, idleEnergy);
end


% keep track of the number of violations that have occurred in a
% simulation.
edfViolations = 0;
lsaViolations = 0;
edfStamViolations = 0;
lsaStamViolations = 0;

% seed each simulation with the same weather patterns
seed = rand() + 11; % Images taken with weather patterns for rand + 7

%%%%% Run EDF simulation
rand('seed', seed);       % initialize rand to known seed
randn('seed', seed);      % initialize randn to known seed
for i = 1 : numEdfSimulations
    % simulate the calculated schedule
    [v, lastEdfBatteryHistory] = simulate(taskList, edfSchedule, simEnd, batteryLevel, idleEnergy, 0);
    edfViolations = edfViolations + v;
end

%%%%% Run LSA simulation
rand('seed', seed);       % initialize rand to known seed
randn('seed', seed);      % initialize randn to known seed
for i = 1 : numLsaSimulations
    % simulate the calculated schedule
    [v, lastLsaBatteryHistory, lsaSchedule] = simulate(taskList, lsaSchedule, simEnd, batteryLevel, idleEnergy, 0);
    lsaViolations = lsaViolations + v;
end

%%%%% Run EDF STFU simulation
rand('seed', seed);       % initialize rand to known seed
randn('seed', seed);      % initialize randn to known seed
for i = 1 : numEdfStamSimulations
    [v, lastEdfStfuBatteryHistory] = simulate(taskList, edfStfuPhysicalSchedule, simEnd, batteryLevel, idleEnergy, 0);
    edfStamViolations = edfStamViolations + v;
end

%%%%% Run LSA STAM simulation
rand('seed', seed);       % initialize rand to known seed
randn('seed', seed);      % initialize randn to known seed
for i = 1 : numLsaStamSimulations
    [v, lastLsaStamBatteryHistory] = simulate(taskList, lsaStamSchedule, simEnd, batteryLevel, idleEnergy, 0);
    lsaStamViolations = lsaStamViolations + v;
end
%numViolations
%stamViolations
edfViolationHistory(j) = edfViolations;
edfStamViolationHistory(j) = edfStamViolations;
lsaViolationHistory(j) = lsaViolations;
lsaStamViolationHistory(j) = lsaStamViolations;

end

if numEdfSimulations
    figure(h1);
    plotSimulation(taskList, edfSchedule, [], [], lastEdfBatteryHistory);
end
if numEdfStamSimulations
    figure(h2);
    plotSimulation(taskList, edfStfuPhysicalSchedule, [], [], lastEdfStfuBatteryHistory);
end
if numLsaSimulations
    figure(h3);
    plotSimulation(taskList, lsaSchedule, [], [], lastLsaBatteryHistory);
end
if numLsaStamSimulations
    figure(h4);
    plotSimulation(taskList, lsaStamSchedule, [], [], lastLsaStamBatteryHistory);
end

































