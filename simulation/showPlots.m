% generate plots

SESSION_NUMBER = 2;

disp(sprintf('Trying to LOAD SESSION_NUMBER: %d',SESSION_NUMBER));
try
  load(sprintf('run_%d',SESSION_NUMBER));
catch
  disp('FAILURE');
end

% plot violations as a function of cpu utilization
utilizationBinCenters =utilizationBinArray + utilizationBinWidth/2;

figure, hold on
%errorbar(utilizationBinCenters,mean(edfViolationHistory),std(edfViolationHistory),'b*-');
%errorbar(utilizationBinCenters,mean(edfViolationHistory),std(edfViolationHistory),'ro-');
%errorbar(utilizationBinCenters,mean(edfViolationHistory),std(edfViolationHistory),'kd-');
%erorbar(utilizationBinCenters,mean(edfViolationHistory),std(edfViolationHistory),'go-');
plot(utilizationBinCenters,mean(edfViolationHistory),'b*-');
plot(utilizationBinCenters,mean(edfStamViolationHistory),'ro-');
plot(utilizationBinCenters,mean(lsaViolationHistory),'kd-');
plot(utilizationBinCenters,mean(lsaStamViolationHistory),'go-');

xlabel('CPU Utilization','FontSize',14);
ylabel('Average Violations','FontSize',14);
h = legend('EDF','EDF-STAM','LSA','LSA-STAM');
set(h,'FontSize',14);




  %edfViolationHistory(j,utilizationIndex) = edfViolations;
  %edfStamViolationHistory(j,utilizationIndex) = edfStamViolations;
  %lsaViolationHistory(j,utilizationIndex) = lsaViolations;
  %lsaStamViolationHistory(j,utilizationIndex) = lsaStamViolations;



% generate plots

%hold all
%plot (utilization, mean(edfViolationHistory));
%plot (utilization, mean(edfStamViolationHistory));
%plot (utilization, mean(lsaViolationHistory));
%plot (utilization, mean(lsaStamViolationHistory));
