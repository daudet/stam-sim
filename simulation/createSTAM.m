function virtualTaskList = createSTAM( taskList )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% createSTAM - create a set of virtual tasks for the input taskList to satisfy	
% the mean energy demand amongst all tasks in the taskList. 
% This is what is known as the smoothing to average method (STAM)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%calculate the mean energy demand across all tasks in the task set
meanEnergy = 0;
taskListSize = size(taskList,1)

	for i = 1:taskListSize
		meanEnergy += taskList(i,3);
	end
	meanEnergy = meanEnergy ./ taskListSize;

%attempt to create virtual tasks for each of the tasks in the task set
virtualTaskList = zeros(taskListSize, 3);

	for i = 1:taskListSize
		% if the tasks energy demand is below the mean energy demand we
		% cannot perform any smoothing
		if (taskList(i,2) ~= meanEnergy)
			actualEnergyArea = taskList(i,2) * taskList(i,3);
			virtualDuration = actualEnergyArea ./ meanEnergy;
			%populate the virtual task set
			virtualTaskList(i,1) = taskList(i,1);
			virtualTaskList(i,2) = virtualDuration;
			virtualTaskList(i,3) = meanEnergy;
		end
	end

% this virtual task set then needs to be checked to see if
% server utilization is greater than 1. 

% The virtual task set then needs to be sent to the schedule* function
% so a schedule can be generated

end
