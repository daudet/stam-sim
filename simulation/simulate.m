function numViolations = simulate(taskSet, scheduleTable, simEnd, batteryLevel, idleEnergy)
%Simulation Framework
%November 26th, 2010

%rand('seed', 0);       % initialize rand to known seed
%randn('seed', 0);      % initialize randn to known seed
clear functions;        % clear persistent values in functions

%define a counter to keep track of the number of energy violations
numViolations = 0;

%B_0
currentBatteryLevel = batteryLevel;

%create an array to store battery history
batteryHistory = zeros(1,simEnd);
batteryHistory(1) = currentBatteryLevel;

%current executing task. If 0 --> idle
curTask = 0;
%finish point of the current task
taskEnd = -1;

%set initial row index of scheduleTable
scheduleIndex = 1;

for t = 0 : simEnd
    if (t == scheduleTable(scheduleIndex,1))
        curTask = scheduleTable(scheduleIndex,2);
        taskEnd =  t + taskSet(curTask,2) - 1;
    end
    
    
    if (curTask == 0)
        energyConsumed = idleEnergy;
    else
        energyConsumed = taskSet(curTask,1); 
    end
    [currentBatteryLevel, radiation] = updateBatteryLevel(currentBatteryLevel, energyConsumed);
    
    %if there is no energy available, there is a violation
    if currentBatteryLevel < 0
        numViolations = numViolations + 1;
    end
    
    s = sprintf('%5d - Running task %d, using energy %.2f (%.2f remaining, charged from irradiance of %.2f W/m2)', t, curTask, energyConsumed, currentBatteryLevel, radiation);
    disp(s)
    
    
    if (taskEnd == t)
        curTask = 0;
        scheduleIndex = mod(scheduleIndex, size(scheduleTable, 1)) + 1;
    end
    
    %update the battery level history
    batteryHistory(t+1) = currentBatteryLevel;
    
    %print the battery history level  
end
disp(' ')
x = 0 : size(batteryHistory, 2) - 1;
plot(x, batteryHistory);
axis([0 simEnd 0 12])

end