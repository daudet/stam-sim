function [taskList, stamTasks, stfuTasks] = generateTaskListBounded(numTasks, utilizationLower, utilizationUpper)
%GENERATETASKLIST Generate a list of periodic tasks with random periods and
%energy demands.
%
% The task list is an n*3 matrix, where n is the number of tasks.  The
% columns are defined as follows:
%       column 1 - The period of the task, in time units
%       column 2 - The duration of the task, in time units
%       column 3 - The task's energy usage per time unit

for i = 1 : 100
    periods = 40*rand(numTasks, 1) + 10;
    durations = 5 * rand(numTasks, 1) + 1;
    energies = abs(0.5*randn(numTasks, 1));
    energies = periods .* energies / 40 + 0.5; % a high-energy task will probably be low-frequency

    taskList = [floor(periods) floor(durations) energies];
    stamTasks = createSTAM(taskList);
    stfuTasks = createSTFU(taskList);

    % if utilization < 1 then tasks are schedulable.  Otherwise try again.
    utilization = sum(taskList(:, 2) ./ taskList(:, 1));
    stamUtilization = sum(stamTasks(:, 2) ./ stamTasks(:, 1));

    if utilization > utilizationLower && utilization < utilizationUpper
        break;
    end

end

if i == 100
    warndlg('Task generator hit recursion limit, it may be too hard to generate a schedulable set of tasks with the given parameters.');
    taskList = [];
end
end

