function schedule = scheduleLSA( taskList, scheduleLength)
%scheduleLSA Generate schedule for the given task list using the lazy scheduling
%algorithm.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%	LSA is defined by the following rules:
%
%	Rule 1: If the current task time equals the deadline of some arrived but not
%			yet finished task, the finish its execution by consuming energy from
%			the power source.
%
%	Rule 2:	We must not waste energy if we could spend it on task execution. If
%			If the capacity limit is reached on the battery, execute the task 
%			with the next earliest deadline.
%	
%	Rule 3: Rule 1 overrules Rule 2.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


t = 1; 
numTasks = size(taskList, 1);

%queue column headers: task#, period, runtime, energy, lastDeadLine, nextDeadline
queue = [(1 : numTasks)' taskList zeros(numTasks, 1) taskList(:, 1)];

schedule = zeros(scheduleLength, 2);
scheduleIndex = 1;

while t < scheduleLength
    %find the task with the next earliest deadline
	queue = sortrows(queue, 6);
    for i = 1 : numTasks
	        if queue(i, 5) < t
            break;
        end
    end
    
	%examine the amount of energy that can be generated in the time between
	%running the task at the first possible time and its deadline
		
	%this avoids spending scarce energy on the wrong task too early
	%uses As Late As Possible (ALAP) policy to allow more energy to be
	%gathered from the environment energy source

	%need to add some form of energy prediction based on a lower bound energy
	%state of the Markovian model

    if queue(i, 5) >= t
        % skip ahead to the next task's runtime (this could be optimized)
        t = t + 1;
        continue;
    end
    % i is the index of the task with the earliest deadline that hasn't
    % already run during this period
    taskinfo = num2cell(queue(i,:));
    [task, period, runtime, energy, lastDeadline, nextDeadline] = taskinfo{:};
    %s = sprintf('Task %2d scheduled to run at time %5d (last deadline was %5d, this deadline was %5d).', task, t, lastDeadline, nextDeadline);
    %disp(s);
    
    schedule(scheduleIndex, 1) = t;
    schedule(scheduleIndex, 2) = task;
    scheduleIndex = scheduleIndex + 1;
    
    %d = nextDeadline;
    lastDeadline = nextDeadline;
    nextDeadline = nextDeadline + period;
    queue(i,:) = [task, period, runtime, energy, lastDeadline, nextDeadline];
    t = t + runtime;
end

% strip the trailing zeros from the schedule array
schedule = [schedule(schedule(:,1) ~= 0, 1) schedule(schedule(:,2) ~= 0, 2)];

end

