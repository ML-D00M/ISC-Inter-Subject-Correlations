function [ISC,ISC_persubject,ISC_persecond,W,A] = isceeg(datafile)

% some ISC processing parameters
gamma = 0.1; % shrinkage parameter; smaller gamma for less regularization
Ncomp = 3;  % number of components to dispaly (all D are computed)
fs=500; % in Hz

% Load the data
load('pr_p_msk.mat','PR');
X=PR;
% X=X(:,setdiff(1:D,[5 25]),:)
clear PR

% Take only subjects with good signal.
% e.g. suppose that only subjects 4, 5, 7 and 12 have good signal.
% X=X(:,:,[4 5 7 12]);

% T samples, D channels, N subjects
[T,D,N] = size(X); 

% now start the ISC code proper

% compute cross-covariance between all subjects i and j
Rij = permute(reshape(cov(X(:,:)),[D N  D N]),[1 3 2 4]); 

% compute within- and between-subject covariances
Rw =       1/N* sum(Rij(:,:,1:N+1:N*N),3);  % pooled over all subjects
Rb = 1/(N-1)/N*(sum(Rij(:,:,:),3) - N*Rw);  % pooled over all pairs of subjects

% shrinkage regularization of Rw
Rw_reg = (1-gamma)*Rw + gamma*mean(eig(Rw))*eye(size(Rw));

% compute correlated components W using regularized Rw, sort components by ISC
[W,ISC]=eig(Rb,Rw_reg); [ISC,indx]=sort(diag(ISC),'descend'); W=W(:,indx);
% ISC

% compute forward model ("scalp projections") A
 A=Rw*W/(W'*Rw*W);

% +++ If multiple stimuli are available, then Rij as computed for each stimulus
% should be used in the following to compute ISC_persubject, and
% ISC_persecond +++

% Compute ISC resolved by subject, see Cohen et al.
% Every row corresponds to one component, every column
% corresponds to each subject.
for i=1:N
    Rw=0; for j=1:N, if i~=j, Rw = Rw+1/(N-1)*(Rij(:,:,i,i)+Rij(:,:,j,j)); end; end
    Rb=0; for j=1:N, if i~=j, Rb = Rb+1/(N-1)*(Rij(:,:,i,j)+Rij(:,:,j,i)); end; end
    ISC_persubject(:,i) = diag(W'*Rb*W)./diag(W'*Rw*W);
end

% Sum the 3 strongest components and save it as a vector
ISC_persubject_sum=sum(ISC_persubject(1:3,:),1);
% save([datafile 'ISC_persubject_sum.mat'],'ISC_persubject_sum');

% ISC across time windows
Nsec  = 1;  % time-window (in seconds) over which to compute time-reposeved ISC
overlap = 0.8*Nsec;
t = 1:floor((Nsec-overlap)*fs+1):(T-fs*Nsec);
for tau=1:length(t)
    Xt = X(t(tau):(t(tau)+Nsec*fs-1),:,:);
    Rij = permute(reshape(cov(Xt(:,:)),[D N  D N]),[1 3 2 4]);
    Rw =  1/N* sum(Rij(:,:,1:N+1:N*N),3);  % pooled over all subjects
    Rb = 1/(N-1)/N*(sum(Rij(:,:,:),3) - N*Rw);  % pooled over all pairs of subjects
    ISC_persecond(:,tau) = diag(W'*Rb*W)./diag(W'*Rw*W);
end

% Plot the ISC time series
avg_vis=0.5;
for tau=2:length(t)
    avg_vis(tau)=avg_vis(tau-1)+0.2;
end
figure(1)
for i=1:3
    subplot(3,1,i)
    plot(avg_vis,ISC_persecond(i,:))
    ylim([-0.05 0.2]);
    xlabel('Seconds')
    title(['Component ' num2str(i)])
    ylabel('ISC')
end

% Check for statistical significance
fprintf('Running 100 permutations...')
chance_val=[];
for iter=1:100
    Xr=phase_randomized(X);
    fprintf('.')

    t = 1:floor((Nsec-overlap)*fs+1):(T-fs*Nsec);
    for tau=1:length(t)
        Xt = Xr(t(tau):(t(tau)+Nsec*fs-1),:,:);
        Rij = permute(reshape(cov(Xt(:,:)),[D N  D N]),[1 3 2 4]);
        Rw = 1/N* sum(Rij(:,:,1:N+1:N*N),3);  % pooled over all subjects
        Rb = 1/(N-1)/N*(sum(Rij(:,:,:),3) - N*Rw);  % pooled over all pairs of subjects
        rISC_perwindow(:,tau) = diag(W'*Rb*W)./diag(W'*Rw*W);
    end
    chance_val(:,:,iter)=rISC_perwindow';
end

fprintf('Getting the p-values...')
pvals=stat_surrogate_pvals(chance_val,ISC_persecond');

% Adjust for multiple comparisons

% save(strcat('pvals',num2str(video),'.mat'),'pvals');
p1=pvals(:,1);
p2=pvals(:,2);
p3=pvals(:,3);

%Check what is the percentage of significant windows in the 1st component
length(find(p1<0.05))/length(p1)

% show some results
%for i=1:3
 %   subplot(1,3,i);
  %  topoplot(A(:,i),'BioSemi64_edit.loc','electrodes','on'); title(['Component ' num2str(i)])
%end
% colorbar

notBoxPlot(ISC_persubject(1:Ncomp,:)'); xlabel('Component'); ylabel('ISC'); title('Per subjects');
plot(ISC_persecond(1:Ncomp,:)'); xlabel('Time (s)'); ylabel('ISC'); title('Per second');

% Load the data
load('pr_h_msk.mat','PR');
X=PR;
% X=X(:,setdiff(1:D,[5 25]),:)
clear PR

% Take only subjects with good signal.
% e.g. suppose that only subjects 4, 5, 7 and 12 have good signal.
% X=X(:,:,[4 5 7 12]);

% T samples, D channels, N subjects
[T,D,N] = size(X); 

% now start the ISC code proper

% compute cross-covariance between all subjects i and j
Rij = permute(reshape(cov(X(:,:)),[D N  D N]),[1 3 2 4]); 

% compute within- and between-subject covariances
Rw =       1/N* sum(Rij(:,:,1:N+1:N*N),3);  % pooled over all subjects
Rb = 1/(N-1)/N*(sum(Rij(:,:,:),3) - N*Rw);  % pooled over all pairs of subjects

% shrinkage regularization of Rw
Rw_reg = (1-gamma)*Rw + gamma*mean(eig(Rw))*eye(size(Rw));

% compute correlated components W using regularized Rw, sort components by ISC
[W,ISC]=eig(Rb,Rw_reg); [ISC,indx]=sort(diag(ISC),'descend'); W=W(:,indx);
% ISC

% compute forward model ("scalp projections") A
 A=Rw*W/(W'*Rw*W);

% +++ If multiple stimuli are available, then Rij as computed for each stimulus
% should be used in the following to compute ISC_persubject, and
% ISC_persecond +++

% Compute ISC resolved by subject, see Cohen et al.
% Every row corresponds to one component, every column
% corresponds to each subject.
for i=1:N
    Rw=0; for j=1:N, if i~=j, Rw = Rw+1/(N-1)*(Rij(:,:,i,i)+Rij(:,:,j,j)); end; end
    Rb=0; for j=1:N, if i~=j, Rb = Rb+1/(N-1)*(Rij(:,:,i,j)+Rij(:,:,j,i)); end; end
    ISC_persubject(:,i) = diag(W'*Rb*W)./diag(W'*Rw*W);
end

% Sum the 3 strongest components and save it as a vector
ISC_persubject_sum=sum(ISC_persubject(1:3,:),1);
% save([datafile 'ISC_persubject_sum.mat'],'ISC_persubject_sum');

% ISC across time windows
Nsec  = 1;  % time-window (in seconds) over which to compute time-reposeved ISC
overlap = 0.8*Nsec;
t = 1:floor((Nsec-overlap)*fs+1):(T-fs*Nsec);
for tau=1:length(t)
    Xt = X(t(tau):(t(tau)+Nsec*fs-1),:,:);
    Rij = permute(reshape(cov(Xt(:,:)),[D N  D N]),[1 3 2 4]);
    Rw =  1/N* sum(Rij(:,:,1:N+1:N*N),3);  % pooled over all subjects
    Rb = 1/(N-1)/N*(sum(Rij(:,:,:),3) - N*Rw);  % pooled over all pairs of subjects
    ISC_persecond(:,tau) = diag(W'*Rb*W)./diag(W'*Rw*W);
end

% Plot the ISC time series
avg_vis=0.5;
for tau=2:length(t)
    avg_vis(tau)=avg_vis(tau-1)+0.2;
end
figure(1)
for i=1:3
    subplot(3,1,i)
    plot(avg_vis,ISC_persecond(i,:))
    ylim([-0.05 0.2]);
    xlabel('Seconds')
    title(['Component ' num2str(i)])
    ylabel('ISC')
end

% Check for statistical significance
fprintf('Running 100 permutations...')
chance_val=[];
for iter=1:100
    Xr=phase_randomized(X);
    fprintf('.')

    t = 1:floor((Nsec-overlap)*fs+1):(T-fs*Nsec);
    for tau=1:length(t)
        Xt = Xr(t(tau):(t(tau)+Nsec*fs-1),:,:);
        Rij = permute(reshape(cov(Xt(:,:)),[D N  D N]),[1 3 2 4]);
        Rw = 1/N* sum(Rij(:,:,1:N+1:N*N),3);  % pooled over all subjects
        Rb = 1/(N-1)/N*(sum(Rij(:,:,:),3) - N*Rw);  % pooled over all pairs of subjects
        rISC_perwindow(:,tau) = diag(W'*Rb*W)./diag(W'*Rw*W);
    end
    chance_val(:,:,iter)=rISC_perwindow';
end

fprintf('Getting the p-values...')
pvals=stat_surrogate_pvals(chance_val,ISC_persecond');

% Adjust for multiple comparisons

% save(strcat('pvals',num2str(video),'.mat'),'pvals');
p1=pvals(:,1);
p2=pvals(:,2);
p3=pvals(:,3);

%Check what is the percentage of significant windows in the 1st component
length(find(p1<0.05))/length(p1)

% show some results
%for i=1:3
 %   subplot(1,3,i);
  %  topoplot(A(:,i),'BioSemi64_edit.loc','electrodes','on'); title(['Component ' num2str(i)])
%end
% colorbar

notBoxPlot(ISC_persubject(1:Ncomp,:)'); xlabel('Component'); ylabel('ISC'); title('Per subjects');
plot(ISC_persecond(1:Ncomp,:)'); xlabel('Time (s)'); ylabel('ISC'); title('Per second');

% Load the data
load('mov.mat','PR');
X=PR;
% X=X(:,setdiff(1:D,[5 25]),:)
clear PR

% Take only subjects with good signal.
% e.g. suppose that only subjects 4, 5, 7 and 12 have good signal.
% X=X(:,:,[4 5 7 12]);

% T samples, D channels, N subjects
[T,D,N] = size(X); 

% now start the ISC code proper

% compute cross-covariance between all subjects i and j
Rij = permute(reshape(cov(X(:,:)),[D N  D N]),[1 3 2 4]); 

% compute within- and between-subject covariances
Rw =       1/N* sum(Rij(:,:,1:N+1:N*N),3);  % pooled over all subjects
Rb = 1/(N-1)/N*(sum(Rij(:,:,:),3) - N*Rw);  % pooled over all pairs of subjects

% shrinkage regularization of Rw
Rw_reg = (1-gamma)*Rw + gamma*mean(eig(Rw))*eye(size(Rw));

% compute correlated components W using regularized Rw, sort components by ISC
[W,ISC]=eig(Rb,Rw_reg); [ISC,indx]=sort(diag(ISC),'descend'); W=W(:,indx);
% ISC

% compute forward model ("scalp projections") A
 A=Rw*W/(W'*Rw*W);

% +++ If multiple stimuli are available, then Rij as computed for each stimulus
% should be used in the following to compute ISC_persubject, and
% ISC_persecond +++

% Compute ISC resolved by subject, see Cohen et al.
% Every row corresponds to one component, every column
% corresponds to each subject.
for i=1:N
    Rw=0; for j=1:N, if i~=j, Rw = Rw+1/(N-1)*(Rij(:,:,i,i)+Rij(:,:,j,j)); end; end
    Rb=0; for j=1:N, if i~=j, Rb = Rb+1/(N-1)*(Rij(:,:,i,j)+Rij(:,:,j,i)); end; end
    ISC_persubject(:,i) = diag(W'*Rb*W)./diag(W'*Rw*W);
end

% Sum the 3 strongest components and save it as a vector
ISC_persubject_sum=sum(ISC_persubject(1:3,:),1);
% save([datafile 'ISC_persubject_sum.mat'],'ISC_persubject_sum');

% ISC across time windows
Nsec  = 1;  % time-window (in seconds) over which to compute time-reposeved ISC
overlap = 0.8*Nsec;
t = 1:floor((Nsec-overlap)*fs+1):(T-fs*Nsec);
for tau=1:length(t)
    Xt = X(t(tau):(t(tau)+Nsec*fs-1),:,:);
    Rij = permute(reshape(cov(Xt(:,:)),[D N  D N]),[1 3 2 4]);
    Rw =  1/N* sum(Rij(:,:,1:N+1:N*N),3);  % pooled over all subjects
    Rb = 1/(N-1)/N*(sum(Rij(:,:,:),3) - N*Rw);  % pooled over all pairs of subjects
    ISC_persecond(:,tau) = diag(W'*Rb*W)./diag(W'*Rw*W);
end

% Plot the ISC time series
avg_vis=0.5;
for tau=2:length(t)
    avg_vis(tau)=avg_vis(tau-1)+0.2;
end
figure(1)
for i=1:3
    subplot(3,1,i)
    plot(avg_vis,ISC_persecond(i,:))
    ylim([-0.05 0.2]);
    xlabel('Seconds')
    title(['Component ' num2str(i)])
    ylabel('ISC')
end

% Check for statistical significance
fprintf('Running 100 permutations...')
chance_val=[];
for iter=1:100
    Xr=phase_randomized(X);
    fprintf('.')

    t = 1:floor((Nsec-overlap)*fs+1):(T-fs*Nsec);
    for tau=1:length(t)
        Xt = Xr(t(tau):(t(tau)+Nsec*fs-1),:,:);
        Rij = permute(reshape(cov(Xt(:,:)),[D N  D N]),[1 3 2 4]);
        Rw = 1/N* sum(Rij(:,:,1:N+1:N*N),3);  % pooled over all subjects
        Rb = 1/(N-1)/N*(sum(Rij(:,:,:),3) - N*Rw);  % pooled over all pairs of subjects
        rISC_perwindow(:,tau) = diag(W'*Rb*W)./diag(W'*Rw*W);
    end
    chance_val(:,:,iter)=rISC_perwindow';
end

fprintf('Getting the p-values...')
pvals=stat_surrogate_pvals(chance_val,ISC_persecond');

% Adjust for multiple comparisons

% save(strcat('pvals',num2str(video),'.mat'),'pvals');
p1=pvals(:,1);
p2=pvals(:,2);
p3=pvals(:,3);

%Check what is the percentage of significant windows in the 1st component
length(find(p1<0.05))/length(p1)

% show some results
%for i=1:3
 %   subplot(1,3,i);
  %  topoplot(A(:,i),'BioSemi64_edit.loc','electrodes','on'); title(['Component ' num2str(i)])
%end
% colorbar

notBoxPlot(ISC_persubject(1:Ncomp,:)'); xlabel('Component'); ylabel('ISC'); title('Per subjects');
plot(ISC_persecond(1:Ncomp,:)'); xlabel('Time (s)'); ylabel('ISC'); title('Per second');


