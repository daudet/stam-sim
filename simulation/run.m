% create taskSet Table
% column 1 is energy consumed per time unit, column 2 task duration
taskSet = generateTaskSet(4);

% set some value for idle task energy demand
idleEnergy = 0.1;

% set initial battery level
batteryLevel = 12;

% end time for simulation
simEnd = 100;

% static schedule table
% column 1 is start time, column 2 task number
scheduleTable = scheduleEDF(taskSet, simEnd);

visual = zeros(simEnd,4)';

for tableIndex = 1 : simEnd
    taskNum = scheduleTable(tableIndex,2);
    execTime = scheduleTable(tableIndex,1);
    if taskNum ~= 0
        for timeSlice = execTime : ((execTime + taskSet(taskNum,2)) - 1)
            visual(taskNum, timeSlice) = taskSet(taskNum,3);
        end
    end
end

% visualize simulation
clf;    % clear the figure window
vstep = 1.2 * max(max(visual));     % vertical step to fit four 
subplot(2,1,1)
hold on
stairs((0:size(visual,2)-1) , visual(1,:));
stairs((0:size(visual,2)-1) , visual(2,:) - vstep);
stairs((0:size(visual,2)-1) , visual(3,:) - 2*vstep);
stairs((0:size(visual,2)-1) , visual(4,:) - 3*vstep);
hold off

% keep track of the number of violations that have occurred in a
% simulation.
numViolations = 0;

for i = 1 : 1
% simulate the calculated schedule
numViolations = numViolations + simulate(taskSet, scheduleTable, simEnd, batteryLevel, idleEnergy, 0);
end
numViolations