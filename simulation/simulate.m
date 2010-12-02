function [violation, batteryHistory] = simulate(taskList, scheduleTable, simEnd, batteryLevel, idleEnergy)
%Simulation Framework
%November 26th, 2010

%define a counter to keep track of the number of energy violations
violation = 0;

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

for t = 1 : simEnd
    if (t == scheduleTable(scheduleIndex,1))
        curTask = scheduleTable(scheduleIndex,2);
        taskEnd =  t + taskList(curTask,2) - 1;
    end
    
    
    if (curTask == 0)
        energyConsumed = idleEnergy;
    else
        energyConsumed = taskList(curTask,3); 
    end
    [currentBatteryLevel, radiation] = updateBatteryLevel(currentBatteryLevel, energyConsumed);
    
    %if there is no energy available, there is a violation
    if currentBatteryLevel < 0
        violation = 1;
        break;
    end
    
%    s = sprintf('%5d - Running task %d, using energy %.2f (%.2f remaining, charged from irradiance of %.2f W/m2)', t, curTask, energyConsumed, currentBatteryLevel, radiation);
%    disp(s)
    
    if (taskEnd == t)
        curTask = 0;
        scheduleIndex = mod(scheduleIndex, size(scheduleTable, 1)) + 1;
    end
    
    %update the battery level history
    batteryHistory(t+1) = currentBatteryLevel;
end

end