
% cd ISC/data/HSE/arthrogryposis/kids

% Read the data of all the subjects
% They are in .csv format after step1.
files=dir('*.mat');
disp(length(files))

for sub=1:length(files)
	
	thisSubject=files(sub).name;
	load(thisSubject);
	data=signal;
	triggers=data(:,size(data,2));
	
	%%%%%%%%%% Extract the recordings of video 1
	fprintf('Segmenting video 1 - Highway SPb...')
	h_spb_start=find(triggers==1);  % The onset of video 1 corresponds to the trigger code 1
	
    % 05:00.053 — 300053 ms — video duration
	h_spb=data(h_spb_start:(h_spb_start+150026),1:(size(data,2)-2)); % The video lasts 150000 time samples
	save(strcat('h_spb_',thisSubject(1:length(thisSubject)-4),'.mat'),'h_spb');

    
	%%%%%%%%%% Extract the recordings of video 2
	fprintf('Segmenting video 2 - Highway Msk...')
	h_msk_start=find(triggers==2); % The onset of video 2 corresponds to the trigger code 2
    
    % 05:00.053 — 300053 ms — video duration
	h_msk=data(h_msk_start:(h_msk_start+150026),1:(size(data,2)-2));
	save(strcat('h_msk_',thisSubject(1:length(thisSubject)-4),'.mat'),'h_msk');
	
    
	%%%%%%%%%% Extract the recordings of video 3
	fprintf('Segmenting video 3 - Park Msk...')
	p_msk_start=find(triggers==3);

    % 05:00.053 — 300053 ms — video duration
	p_msk=data(p_msk_start:(p_msk_start+150026),1:(size(data,2)-2));
	save(strcat('p_msk_',thisSubject(1:length(thisSubject)-4),'.mat'),'p_msk');

    
	%%%%%%%%%% Extract the recordings of video 4
	fprintf('Segmenting video 4 - Park SPb...')
	p_spb_start=find(triggers==4);
    
    % 05:00.053 — 300053 ms — video duration
	p_spb=data(p_spb_start:(p_spb_start+150026),1:(size(data,2)-2));
	save(strcat('p_spb_',thisSubject(1:length(thisSubject)-4),'.mat'),'p_spb');

    
	%%%%%%%%%% Extract the recordings of video 5
	fprintf('Segmenting video 5 - Boulevard SPb...')
	b_spb_start=find(triggers==5);  % The onset of video 5 corresponds to the trigger code 5
	
    % 05:00.053 — 300053 ms — video duration
	b_spb=data(b_spb_start:(b_spb_start+150026),1:(size(data,2)-2)); 
	save(strcat('b_spb_',thisSubject(1:length(thisSubject)-4),'.mat'),'b_spb');
    
    
    %%%%%%%%%% Extract the recordings of video 6
	fprintf('Segmenting video 6 - Boulevard Msk...')
	b_msk_start=find(triggers==6);  % The onset of video 6 corresponds to the trigger code 6
	
    % 05:00.053 — 300053 ms — video duration
	b_msk=data(b_msk_start:(b_msk_start+150026),1:(size(data,2)-2));
	save(strcat('b_msk_',thisSubject(1:length(thisSubject)-4),'.mat'),'b_msk');
    
    
    %%%%%%%%%% Extract the recordings of video 7
	fprintf('Segmenting video 7 - Sea...')
	sea_start=find(triggers==7);  % The onset of video 7 corresponds to the trigger code 7
	
    % 05:00.096 — 300096 ms — video duration
	sea=data(sea_start:(sea_start+150048),1:(size(data,2)-2));
	save(strcat('sea_',thisSubject(1:length(thisSubject)-4),'.mat'),'sea');
    
    
    %%%%%%%%%% Extract the recordings of video 8
	fprintf('Segmenting video 8 - Blurred...')
	blur_start=find(triggers==8);  % The onset of video 8 corresponds to the trigger code 8
	
    % 05:00.096 — 300096 ms — video duration
	blur=data(blur_start:(blur_start+150048),1:(size(data,2)-2));
	save(strcat('blur_',thisSubject(1:length(thisSubject)-4),'.mat'),'blur');
    
    
    %%%%%%%%%% Extract the recordings of video 9
	fprintf('Segmenting video 9 - Movie...')
	mov_start=find(triggers==9);
	
    % 05:00.586 — 300586 — video duration
	mov=data(mov_start:(mov_start+150293),1:(size(data,2)-2));
	save(strcat('mov_',thisSubject(1:length(thisSubject)-4),'.mat'),'mov');

	fprintf(strcat('All good with subject_',thisSubject(1:length(thisSubject)-4)))
	
end

disp('Done with all!!!')