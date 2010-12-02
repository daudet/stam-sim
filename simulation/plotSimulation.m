function plotSimulation( taskList, schedule, stamTasks, stamEquivalent, batteryHistory )
%PLOTSIMULATION Summary of this function goes here
%   Detailed explanation goes here

simEnd = max(size(stamEquivalent, 1), size(schedule, 1));
visual = zeros(simEnd,4)';
stamVisual = zeros(simEnd,4)';

for tableIndex = 1 : simEnd
    taskNum = schedule(tableIndex,2);
    execTime = schedule(tableIndex,1);
    if taskNum ~= 0
        for timeSlice = execTime : ((execTime + taskList(taskNum,2)) - 1)
            visual(taskNum, timeSlice) = taskList(taskNum,3);
        end
    end
    if ~isempty(stamEquivalent)
        taskNum = stamEquivalent(tableIndex,2);
        execTime = stamEquivalent(tableIndex,1);
        if taskNum ~= 0
            for timeSlice = execTime : ((execTime + stamTasks(taskNum,2)) - 1)
                stamVisual(taskNum, timeSlice) = stamTasks(taskNum,3);
            end
        end
    end
end

% visualize simulation
clf;    % clear the figure window
vstep = 1.2 * max(max(visual));     % vertical step to fit all task swimlanes
subplot(2,1,1)
hold on
stairs((0:size(visual,2)-1) , visual(1,:));
stairs((0:size(visual,2)-1) , visual(2,:) - vstep);
stairs((0:size(visual,2)-1) , visual(3,:) - 2*vstep);
stairs((0:size(visual,2)-1) , visual(4,:) - 3*vstep);
if ~isempty(stamEquivalent)
    % plot the STAM equivalent in green if it's defined
    % We're putting the STAM tasks slightly out of phase so that STAM tasks and
    % regular tasks are both visible when they are scheduled at the same
    % time
    stairs((0:size(stamVisual,2)-1) + 0.002*simEnd , stamVisual(1,:), 'Color', 'green');
    stairs((0:size(stamVisual,2)-1) + 0.002*simEnd , stamVisual(2,:) - vstep, 'Color', 'green');
    stairs((0:size(stamVisual,2)-1) + 0.002*simEnd , stamVisual(3,:) - 2*vstep, 'Color', 'green');
    stairs((0:size(stamVisual,2)-1) + 0.002*simEnd , stamVisual(4,:) - 3*vstep, 'Color', 'green');
end
hold off
axis([0 simEnd (-3.5*vstep) (stamTasks(1,3) + 0.5*vstep)]);

x = 0 : size(batteryHistory, 2) - 1;
subplot(2,1,2);
plot(x, batteryHistory);
axis([0 simEnd 0 12]);

end

