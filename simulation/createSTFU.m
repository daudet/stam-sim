function stfuTasks = createSTFU( taskList )
%format is [period, duration, energy]
stfuTasks = zeros(size(taskList,1), 3);               

utilizations = taskList(:,2) ./ taskList(:,1);
%calculate proportion of energy used by each task
energyShares = utilizations .* taskList(:,3);
%normalize to percent
dutyCycles = energyShares / sum(energyShares);

% column 1 = period remains the same
stfuTasks(:,1) = taskList(:,1);
% column 2 = duration is the larger of the original duration and the
% calculated duty cycle
stfuTasks(:,2) = max(taskList(:,2), floor((taskList(:,1) .* dutyCycles)));
% column 3 = energy is the original total energy spread over the new
% duration
stfuTasks(:,3) = taskList(:,2) .* taskList(:,3) ./ stfuTasks(:,2);
end

