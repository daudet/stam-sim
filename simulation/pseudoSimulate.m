function newScheduleTable = pseudoSimulate(taskList, scheduleTable, simEnd, batteryLevel, idleEnergy)

newScheduleTable = [];

%B_0
currentBatteryLevel = batteryLevel;
maxBatteryLevel = batteryLevel;

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
        if currentBatteryLevel >= maxBatteryLevel
            [scheduleTable, reallocated] = dynamicallyReallocateSchedule(scheduleTable);
            if reallocated
                continue;
            end
        end
        energyConsumed = idleEnergy;
    else
        energyConsumed = taskList(curTask,3); 
    end
    %use lower bound of Markov Energy Model
    currentBatteryLevel = currentBatteryLevel + 0.190 - energyConsumed;
    
    if (taskEnd == t)
        curTask = 0;
        scheduleIndex = mod(scheduleIndex, size(scheduleTable, 1)) + 1;
    end
    t = t + 1;

end

end