function virtualTaskList = createSTAM( taskList )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% createSTAM - create a set of virtual tasks for the input taskList to satisfy	
% the mean energy demand amongst all tasks in the taskList. 
% This is what is known as the smoothing to average method (STAM)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%calculate the mean energy demand across all tasks in the task set
taskListSize = size(taskList,1);

meanEnergy = mean(taskList(:,3));

%attempt to create virtual tasks for each of the tasks in the task set
%format is [period, duration, energy]
virtualTaskList = zeros(taskListSize, 3);

for i = 1 : taskListSize
    if (taskList(i,3) > meanEnergy)
        actualEnergyArea = taskList(i,2) * taskList(i,3);
        virtualDuration = ceil(actualEnergyArea / meanEnergy);
        %populate the virtual task set
        virtualTaskList(i, :) = [taskList(i,1) virtualDuration (actualEnergyArea/virtualDuration)];
    % if the task's energy demand is below the mean energy demand we
    % cannot perform any smoothing
    else
       virtualTaskList(i,:) = taskList(i,:);
    end

end

end
