%Simulation Framework
%November 26th, 2010

%set endpoint for simulation
simEnd = 20;

%define a counter to keep track of the number of energy violations
numViolations = 0;

%B_0
currentBatteryLevel = 12;

%create an array to store battery history
batteryHistory = zeros(1,simEnd);
batteryHistory(1) = currentBatteryLevel;

%set some value for idle task energy demand
idleEnergy = 0.3;

%create taskSet Table
taskSet = [10, 1.5, 3
           21, 4.0, 2];

%static schedule table
%column 1 time, column 2 task#
scheduleTable = [   2,1
                    5,2
                    13,1
                    16,1];


%current executing task. If 0 --> idle
curTask = 0;
%finish point of the current task
taskEnd = 0;

%set initial row index of scheduleTable
scheduleIndex = 1;

for t = 1 : simEnd
    if (t == scheduleTable(scheduleIndex,1))
        curTask = scheduleTable(scheduleIndex,2);
        taskEnd =  t + taskSet(curTask,3);
    end
    
    if (curTask == 0)
        currentBatteryLevel = updateBatteryLevel(currentBatteryLevel, idleEnergy);
    else
       currentBatteryLevel = updateBatteryLevel(currentBatteryLevel, taskSet(curTask,2)); 
    end
    
    %if there is no energy available, there is a violation
    if currentBatteryLevel < 0
        numViolations = numViolations + 1;
    end
    
    %check to see if the current task has completed
    if (taskEnd == t)
        curTask = 0;
    end
    
    %update the battery level history
    batteryHistory(t) = currentBatteryLevel;
    
    %print the battery history level
    batteryHistory
  
end