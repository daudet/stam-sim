function taskSet = generateTaskSet(numTasks)
%GENERATETASKSET Generate a set of periodic tasks with random periods and
%energy demands.
%
% The task set is an n*3 matrix, where n is the number of tasks.  The
% columns are defined as follows:
%       column 1 - The period of the task, in time units
%       column 2 - The duration of the task, in time units
%       column 3 - The task's energy usage per time unit

    function taskSet = generateTaskSetRecurse(numTasks, recursion)
        % guard against infinite recursion
        if recursion > 100
            taskSet = [];
            warndlg('Task generator hit recursion limit, it may be too hard to generate a schedulable set of tasks with the given parameters.');
            return;
        end
        
        periods = 40*rand(numTasks, 1) + 10;
        durations = 5 * rand(numTasks, 1) + 1;
        energies = exprnd(.5, numTasks, 1);
        energies = periods .* energies / 40 + 0.5; % a high-energy task will probably be low-frequency

        taskSet = [floor(periods) floor(durations) energies];

        % if utilization > 1 then the task list is impossible to schedule,
        % so try again.
        utilization = sum(taskSet(1 : numTasks, 2) ./ taskSet(1 : numTasks, 1));
        if utilization > 1
            taskSet = generateTaskSetRecurse(numTasks, recursion + 1);
        end
    end

    taskSet = generateTaskSetRecurse(numTasks, 0);
end

