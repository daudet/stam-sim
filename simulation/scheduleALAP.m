function schedule = scheduleALAP( taskList, scheduleLength)
%scheduleALAP Generate schedule for the given task list using a naive lazy 
%scheduling algorithm (As Late As Possible).

t = 1; 
numTasks = size(taskList, 1);

%queue column headers: task#, period, runtime, energy, lastDeadLine, nextDeadline, latestPossibleStartTime
queue = [(1 : numTasks)' taskList zeros(numTasks, 1) taskList(:, 1), (taskList(:,1)-taskList(:,2))];

schedule = zeros(scheduleLength, 2);
scheduleIndex = 1;
	
	%Since there is no energy prediction or any energy consideration
	%when scheduling using this scheme, we are trying to schedule each
	%event as late as possible without violating its deadline

	% Step 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%	to accomplish this we need to first examine the task's deadline
	%	and subtract the tasks duration to determine the latest possible	
	%	start time for the task
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
	% Step 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%	we next need to determine if the latest start time conflicts
	%	with other scheduled tasks. If there is a conflict, we need to
	%	adjust the start time by moving the task to an earlier start
	%	time.
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

while t < scheduleLength
    
    %sort the rows to find the minimum latest possible start time
    queue = sortrows(queue,7);
    %if there is an overlap, skip to next task in the queue
 	if ((queue(1, 7) + queue(1,3)) > queue(2,7))
        %try and shift the first task forward to accommodate
        overlap = ((queue(1, 7) + queue(1,3)) - queue(2,7));
        %if start time can be moved ahead without going past current
        %time we can accommodate both tasks
        if (queue(1,7) - overlap) > t
           t = queue(1,7) - overlap;
        else
           sprintf('There is a scheduling violation at time %d\n', t)
           break;
        end
        
    else
        %set the start time for the given task
        t = queue(1,7);
    end
    % i is the index of the task with the smallest last possible start time
    taskinfo = num2cell(queue(1,:));
    [task, period, runtime, energy, lastDeadline, nextDeadline, lastPossibleStartTime] = taskinfo{:};
    
	%record the scheduled task in the schedule list
    schedule(scheduleIndex, 1) = t;
    schedule(scheduleIndex, 2) = task;
    scheduleIndex = scheduleIndex + 1;
    
    %d = nextDeadline;
    lastDeadline = nextDeadline;
    nextDeadline = nextDeadline + period;
    queue(1,:) = [task, period, runtime, energy, lastDeadline, nextDeadline, (nextDeadline - runtime)];
    t = t + runtime;
end

% strip the trailing zeros from the schedule array
schedule = [schedule(schedule(:,1) ~= 0, 1) schedule(schedule(:,2) ~= 0, 2)];

end

