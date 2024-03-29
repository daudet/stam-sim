function schedule = scheduleALAP( taskList, scheduleLength)
%scheduleALAP Generate schedule for the given task list using a naive lazy 
%scheduling algorithm (As Late As Possible).

numTasks = size(taskList, 1);

%queue column headers: task#, period, runtime, energy, lastDeadLine, nextDeadline]
queue = [(1 : numTasks)' taskList zeros(numTasks, 1) taskList(:, 1) zeros(numTasks, 1)];

schedule = zeros(scheduleLength, 3);
scheduleIndex = 1;
slotUtilization = zeros(scheduleLength * 2,1);

while ~isempty(find(queue(:, 6) < scheduleLength, 1))
    sortrows(queue, -6);
    for i = 1 : numTasks
        if queue(i, 6) < scheduleLength
            % schedule this task unless its next deadline is beyond the
            % schedule length
            nextRuntime = queue(i,6) - queue(i, 3);
            while ~isempty(find(slotUtilization(nextRuntime : (nextRuntime + queue(i,3) - 1)), 1))
                % find an empty timeslice for the task
                nextRuntime = nextRuntime - 1;
                if (nextRuntime == 0)
                    warning('Aargh');
                end
            end
            schedule(scheduleIndex, :) = [nextRuntime queue(i, 1) queue(i, 5)];
            scheduleIndex = scheduleIndex + 1;
            slotUtilization(nextRuntime : nextRuntime + queue(i, 3) - 1) = ones(queue(i,3), 1);
            queue(i, 5) = queue(i, 6);
            queue(i, 6) = queue(i, 6) + queue(i, 2);
        end
    end
    
end

endIndex = find(schedule(:,1) == 0, 1);
schedule = schedule(1:endIndex-1, :);
schedule = sortrows(schedule, 1);
	
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

% while t < scheduleLength
%     
%     %sort the rows to find the minimum latest possible start time
%     queue = sortrows(queue,7);
%     %if there is an overlap, skip to next task in the queue
%     if ((queue(1, 7) + queue(1,3)) > queue(2,7))
%         %try and shift the first task forward to accommodate
%         overlap = ((queue(1, 7) + queue(1,3)) - queue(2,7));
%         %if start time can be moved ahead without going past current
%         %time we can accommodate both tasks
%         if (queue(1,7) - overlap) > t
%            t = queue(1,7) - overlap;
%         else
%            sprintf('There is a scheduling violation at time %d\n', t)
%            break;
%         end
%         
%     else
%         %set the start time for the given task
%         t = queue(1,7);
%     end
%     % i is the index of the task with the smallest last possible start time
%     taskinfo = num2cell(queue(1,:));
%     [task, period, runtime, energy, lastDeadline, nextDeadline, lastPossibleStartTime] = taskinfo{:};
%     
% 	%record the scheduled task in the schedule list
%     schedule(scheduleIndex, 1) = t;
%     schedule(scheduleIndex, 2) = task;
%     scheduleIndex = scheduleIndex + 1;
%     
%     %d = nextDeadline;
%     lastDeadline = nextDeadline;
%     nextDeadline = nextDeadline + period;
%     queue(1,:) = [task, period, runtime, energy, lastDeadline, nextDeadline, (nextDeadline - runtime)];
%     t = t + runtime;
% end

% strip the trailing zeros from the schedule array

end

