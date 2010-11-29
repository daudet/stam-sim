function schedule = scheduleEDF( taskList, scheduleLength)
%SCHEDULEEDF Generate an earliest-deadline-first schedule for the given
%tasks.
t = 1; 
numTasks = size(taskList, 1);

%queue column headers: task#, period, runtime, energy, lastDeadLine, nextDeadline
queue = [(1 : numTasks)' taskList zeros(numTasks, 1) taskList(:, 1)];

schedule = zeros(scheduleLength, 2);
scheduleIndex = 1;

while t < scheduleLength
    queue = sortrows(queue, 6);
    for i = 1 : numTasks
        if queue(i, 5) < t
            break;
        end
    end
    if queue(i, 5) >= t
        % skip ahead to the next task's runtime (this could be optimized)
        t = t + 1;
        continue;
    end
    % i is the index of the task with the earliest deadline that hasn't
    % already run during this period
    taskinfo = num2cell(queue(i,:));
    [task, period, runtime, energy, lastDeadline, nextDeadline] = taskinfo{:};
    s = sprintf('Task %2d scheduled to run at time %5d (last deadline was %5d, this deadline was %5d).', task, t, lastDeadline, nextDeadline);
    disp(s);
    
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
[schedule(schedule(:,1) ~= 0, 1) schedule(schedule(:,2) ~= 0, 2)]

end

