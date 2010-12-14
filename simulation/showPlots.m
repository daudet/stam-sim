% generate plots
close all
clear all

SESSION_NUMBER = 3;

disp(sprintf('Trying to LOAD SESSION_NUMBER: %d',SESSION_NUMBER));
try
  load(sprintf('run_%d',SESSION_NUMBER));
catch
  disp('FAILURE');
end

% plot violations as a function of cpu utilization
utilizationBinCenters =utilizationBinArray + utilizationBinWidth/2;

index = find( lsaStamViolationHistory(:,5) ~= -1 );
lsaStamViolationHistory = lsaStamViolationHistory(index,:);

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
h = legend('EDF','EDF-STFU','LSA','LSA-STAM');
set(h,'FontSize',14);


% bar plot with Neil's values
Data1 = [ 5.22, 4.55, 2.36, 2.07, 1.82, 1.4, 1.1 ];

Data2 = [5.22, 4.44, 1.6, 0.45, 0.46, 0.45, 0.46 ]; 

figure, barh(fliplr(Data1));
xlabel('Average Violations','FontSize',14);
set(gca,'YTickLabel',fliplr({'EDF', 'EDF-STAM', 'EDF STFU', 'ALAP', 'ALAP-STAM','LSA','LSA STAM'}));
set(gca,'FontSize',14); 

figure, barh(fliplr(Data2));
xlabel('Average Violations','FontSize',14);
set(gca,'YTickLabel',fliplr({'EDF', 'EDF-STAM', 'EDF STFU', 'ALAP', 'ALAP-STAM','LSA','LSA STAM'}));
set(gca,'FontSize',14); 


