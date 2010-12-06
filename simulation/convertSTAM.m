function realSchedule = convertSTAM( taskList, stamTaskList, virtualSchedule )
%CONVERTSTAM Convert a virtual schedule to the real equivalent
%   The virtual schedule is a schedule of STAM tasks.  We assume that the
%   virtual tasks are not scheduled to overlap.  The real schedule output
%   has the real tasks scheduled somewhere within the timeslice of the
%   corresponding virtual task.

realSchedule = zeros(size(virtualSchedule, 1), 2);

for i = 1 : size(virtualSchedule, 1)
    taskNum = virtualSchedule(i, 2);
    if taskList(taskNum, 2) == stamTaskList(taskNum, 2)
        % The duration didn't change, so just copy the task over
        realSchedule(i, :) = virtualSchedule(i,:);
    else
        % Slot the real task into the end of the virtual task timeslice.
        startTime = virtualSchedule(i,1) + stamTaskList(taskNum, 2) - taskList(taskNum, 2);
        realSchedule(i, :) = [startTime taskNum];
    end
end

end

