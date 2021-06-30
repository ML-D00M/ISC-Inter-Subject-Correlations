# %cd ISC/data/HSE/arthrogryposis/kids

# % Read the data of all the subjects
files=dir('*.vhdr');

# % Run for every subject

for sub=1:length(files)

   thisSubject=files(sub).name;
   fprintf(strcat('Running for subject ',thisSubject))
    
   # % Read the data
   path=pwd;
   data=pop_loadbv(path,thisSubject);
   signal=data.data';
   T=size(signal,1);  % Time points for each channel
   D=size(signal,2);  % Number of channels
    
   # % Read the triggers.
   triggerCode={};
   triggerTime={};
   for i=1:length(data.event)
       triggerCode{i}=data.event(i).type;
       triggerTime{i}=data.event(i).latency;
   end
   
   # % Align them with the recordings
   triggers=zeros(T,1);
   for i=2:length(triggerTime)
       thisTime=triggerTime{i};
       thisCode=triggerCode{i};
       thisCodeNum=str2num(thisCode(2:length(thisCode)));
       triggers(thisTime)=thisCodeNum;
   end
   
   signal=[signal triggers];
   disp(size(signal))

   # % Save the complete matrix (data + triggers)
   save(strcat(thisSubject(1:length(thisSubject)-5),'.mat'),'signal');

   
end
