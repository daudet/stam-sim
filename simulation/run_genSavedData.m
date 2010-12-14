clear all
close all

SESSION_NUMBER = 3;

numRuns = 100;
numSims = 100;
numEdfSimulations = numSims;
numLsaSimulations = numSims;
numEdfStamSimulations = numSims;
numLsaStamSimulations = numSims;

edfViolationHistory = zeros(numRuns + 1,1);
edfStamViolationHistory = zeros(numRuns + 1, 1);
lsaViolationHistory = zeros(numRuns + 1,1);
lsaStamViolationHistory = zeros(numRuns + 1, 1);

% set some value for idle task energy demand
idleEnergy = 0.05;

% set initial battery level
batteryLevel = 12;

% end time for simulation
simEnd = 100;

disp(sprintf('SESSION_NUMBER: %d, running simulation with %d runs, %d numSims, %d sim end time',SESSION_NUMBER, numRuns, numSims, simEnd));

tic
for j = 1 : numRuns
  
  disp(sprintf('run %d',j)); 


  %rand('seed', seed);       % initialize rand to known seed
  %randn('seed', seed);      % initialize randn to known seed
  %clear functions;        % clear persistent values in functions

  % create real task list and schedule the real tasks
  if j == 48
      j;
  end
  %[taskList, stamTasks] = generateTaskList(4);

  utilizationBinArray = [ 0.2, 0.3, 0.4, 0.5, 0.6];
  utilizationBinWidth = 0.1;

  for utilizationIndex = 1:length( utilizationBinArray ) 
    utilizationBin = utilizationBinArray(utilizationIndex);

    seed = j + 100 + utilizationIndex*numRuns;

    % seed each simulation with the next random number
    %seed = rand();

    %generate a task list within some utilization bound
    [taskList, stamTasks, stfuTasks] = generateTaskListBounded(4,utilizationBin,utilizationBin+utilizationBinWidth);

    if numLsaSimulations > 0 || numLsaStamSimulations > 0
        %use pseudoSimulate to use energy predictive ALAP algorithm
        lsaSchedule = pseudoSimulate(taskList, scheduleALAP(taskList, simEnd), batteryLevel, idleEnergy, 0);

        %lsaSchedule = scheduleALAP(taskList, simEnd);
        lsa_sched_broke = false;
        try
          lsaStamSchedule = pseudoSimulate(taskList, convertSTAM(taskList, stamTasks, scheduleALAP(stamTasks, simEnd)), simEnd, batteryLevel, idleEnergy);
        catch
          lsa_sched_broke = true;
        end
    end

    edfSchedule = scheduleEDF(taskList, simEnd);

    %create STAM task list and schedule the virtual tasks
    edfStamSchedule = convertSTAM(taskList, stfuTasks, scheduleEDF(stfuTasks, simEnd));

    % keep track of the number of violations that have occurred in a
    % simulation.
    edfViolations = 0;
    lsaViolations = 0;
    edfStamViolations = 0;
    lsaStamViolations = 0;


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
        [v, lastBatteryHistory] = simulate(taskList, lsaSchedule, simEnd, batteryLevel, idleEnergy, 0);
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
    if ~lsa_sched_broke
      rand('seed', seed);       % initialize rand to known seed
      randn('seed', seed);      % initialize randn to known seed
      for i = 1 : numLsaStamSimulations
          [v, lastBatteryHistory] = simulate(taskList, lsaStamSchedule, simEnd, batteryLevel, idleEnergy, 0);
          lsaStamViolations = lsaStamViolations + v;
      end
    else
      lsaStamViolations = -1;
    end
    
    % save data from this run
    pwrUsage(j,utilizationIndex) = sum((taskList(:,3).*  taskList(:,2)) ./ taskList(:,1));
    edfViolationHistory(j,utilizationIndex) = edfViolations;
    edfStamViolationHistory(j,utilizationIndex) = edfStamViolations;
    lsaViolationHistory(j,utilizationIndex) = lsaViolations;
    lsaStamViolationHistory(j,utilizationIndex) = lsaStamViolations;
  end
end
time = toc;

disp(sprintf('SAVING as SESSION_NUMBER: %d',SESSION_NUMBER));
save(sprintf('run_%d',SESSION_NUMBER));

