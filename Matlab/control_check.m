
% This script takes as input a CxN matrix, where C is the number of
% components and N is the number of subjects

ISC_persubject_sum=sum(ISC_persubject(1:3,:),1)

figure(1)
subplot(2,1,1)
notBoxPlot(ISC_persubject(1:3,:)'); xlabel('Component'); ylabel('ISC'); title('Per subjects');
subplot(2,1,2)
notBoxPlot(ISC_persubject_sum); ylabel('ISC'); title('Per subjects as sum of 3 comps');

figure(2)
plot(ISC_persubject(1,:), ISC_persubject(2,:),'.')