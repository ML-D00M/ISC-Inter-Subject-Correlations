
% This script preprocesses data in a format TxDxN. If you want to run it for the file h_spb.mat do the following.
% If the name of your mat file is different, adjust the script accordingly. Pavel should run it 9 times (for each video)

load('mov.mat','X','fs');
		
% Which electrodes are the HEOG and VEOG channels? You can check either from brainstorm or from the vhdr files -> chanloca -> labels
% If, for instance, it is the 5th and the 25th, then
eogchannels=[5 25];	 % HEOG and VEOG

[T,D,N] = size(X);

% if it is not EOG, then it must be EEG channel
eegchannels = setdiff(1:D,eogchannels);

kIQD=4;        % multiple of interquartile differences to mark as outliers samples
kIQDp=3;       % multiple of interquartile differences to mark as outliers channels
HPcutoff = 0.5; % HP filter cut-off frequequency in Hz. It can also be 1.
	
% pick your preferred high-pass filter
[z,p,k]=butter(5,HPcutoff/fs*2,'high'); sos = zp2sos(z,p,k);
	
% pick your prefered notch-filter - here it is at 50Hz
d = designfilt('bandstopiir','FilterOrder',2, ...
             'HalfPowerFrequency1',49,'HalfPowerFrequency2',51, ...
              'DesignMethod','butter','SampleRate',fs);

% get size
X=double(X);
[T,D,N]=size(X) 
		
	
	
% Preprocess data for all N subjects
for i=1:N

	disp(strcat(['Preprocessing subject ' num2str(i) '...']))
   
	data = X(:,:,i);

	% remove starting offset to avoid filter trancient
	data = data - repmat(data(1,:),T,1);
    
	% high-pass filter
 	data = sosfilt(sos,data);          

	% notch-filter
	data = filtfilt(d, data);

	% Add more notch filter if you need it, similarly. Eg 100Hz, 150Hz,...

    	% regress out eye-movements;
    	data = data - data(:,eogchannels) * (data(:,eogchannels)\data);     
	
	% detect outliers above stdThresh per channel; 
    	data(abs(data)>kIQD*repmat(diff(prctile(data,[25 75])),[size(data,1) 1])) = NaN;
  
    	% remove 40ms before and after;
    	h=[1; zeros(round(0.04*fs)-1,1)];    
    	data = filter(h,1,flipud(filter(h,1,flipud(data))));
	
    	% Mark outliers as 0, to avoid NaN coding and to discount noisy channels
    	data(isnan(data))=0;

    	% Find bad channels based on power ourliers, if not specified "by hand"
    	logpower = log(std(data)); Q=prctile(log(std(data(:,eegchannels))),[25 50 75]);
    	badchannels{i} = find(logpower-Q(2)>kIQDp*(Q(3)-Q(1)));
    	
    	% zero out bad channels
    	data(:,badchannels{i})=0;

    	Y(:,:,i) = data;
    
end

% remove the eog channels as we have used them already
PR = Y(:,eegchannels,:);
disp(size(PR))

save(('mov.mat'),'PR');
