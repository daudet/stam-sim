function plotUtilization(utilization,edfViolationHistory,edfStamViolationHistory,lsaViolationHistory,lsaStamViolationHistory)
%Create a plot of Utilization vs Violation Rate for the different
%algorithms used in the simulation

hold all
plot (utilization, mean(edfViolationHistory));
plot (utilization, mean(edfStamViolationHistory));
plot (utilization, mean(lsaViolationHistory));
plot (utilization, mean(lsaStamViolationHistory));

end