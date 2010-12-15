function plotSimulation( taskList, schedule, stamTasks, stamEquivalent, batteryHistory )
%PLOTSIMULATION Summary of this function goes here
%   Detailed explanation goes here
if ~isempty(stamTasks)
    simEnd = stamEquivalent(size(stamEquivalent,1)) + stamTasks(stamEquivalent(size(stamEquivalent,2), 2), 2) + 1;
else
    simEnd = schedule(size(schedule,1)) + taskList(schedule(size(schedule,2), 2), 2) + 1;
end
visual = zeros(simEnd,4)';
stamVisual = zeros(simEnd,4)';

for tableIndex = 1 : size(schedule, 1)
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
ymin = -3.5*vstep;
ymax = taskList(1,3) + 0.5*vstep;
axis([0 simEnd ymin ymax]);
%title('EDF Schedules for Real and Virtual Tasks', 'FontSize', 12);
xlabel('Time (time units)', 'FontSize', 12);
ylabel('Power', 'FontSize', 12);
set(gca,'YTick', ymin - vstep/2 : (ymax - ymin) / 4 : ymax - vstep/2)
set(gca,'YTickLabel', '|#4|#3|#2|#1|')


x = 0 : size(batteryHistory, 2) - 1;
subplot(2,1,2);
plot(x, batteryHistory);
axis([0 simEnd 0 12]);
%title('Battery Charge History', 'FontSize', 12);
xlabel('Time (time units)', 'FontSize', 12);
ylabel('Battery charge', 'FontSize', 12);
set(gca,'YTickLabel','')

end

