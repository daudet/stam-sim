function [violation, batteryHistory] = simulate(taskList, schedule, simEnd, batteryLevel, idleEnergy, useDynamicScheduling)
%Simulation Framework
%November 26th, 2010

%define a counter to keep track of the number of energy violations
violation = 0;
scheduleTable = schedule;

%B_0
currentBatteryLevel = batteryLevel;
maxBatteryLevel = batteryLevel;

%create an array to store battery history
batteryHistory = zeros(1,simEnd);
batteryHistory(1) = currentBatteryLevel;

%current executing task. If 0 --> idle
curTask = 0;
%finish point of the current task
taskEnd = -1;

%set initial row index of scheduleTable
scheduleIndex = 1;

    function [newSchedule, reallocated] = dynamicallyReallocateSchedule(sched)
        % Try to move a task up
        idleDuration = sched(scheduleIndex, 1) - t;
        reallocated = 0;
        newSchedule = sched;
        for j = scheduleIndex : size(sched, 1)
            if newSchedule(j, 3) < t && taskList(newSchedule(j, 2), 2) <= idleDuration
                % move up the first possible task.  Maybe better to
                % move up the longest possible task.
                newSchedule(j,1) = t;
                newSchedule = sortrows(newSchedule, 1);
                reallocated = 1;
                return;
            end
        end
    end

t = 1;
while t <= simEnd   
    if (t == scheduleTable(scheduleIndex,1))
        curTask = scheduleTable(scheduleIndex,2);
        taskEnd =  t + taskList(curTask,2) - 1;
    end
    
    
    if (curTask == 0)
        if currentBatteryLevel >= maxBatteryLevel - idleEnergy && useDynamicScheduling
            [scheduleTable, reallocated] = dynamicallyReallocateSchedule(scheduleTable);
            if reallocated
                continue;
            end
        end
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
    t = t + 1;
end

end