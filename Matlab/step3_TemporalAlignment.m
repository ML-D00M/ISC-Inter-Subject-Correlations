%%%%% ---------- Temporal alignment for ISC ----------
fprintf('Starting with ISC alignment...')

%%% Video 1

fprintf('Aligning Highway SPb, Video 1...')
files=dir('h_spb*.mat');
subs={};
for i=1:length(files)
	load(files(i).name);
	subs{i}=h_spb;
	clear h_spb
end

H_spb=subs{1};
for i=2:length(subs)
	H_spb(:,:,i)=subs{i};
end

disp(size(H_spb))

h_spb.X=H_spb;
h_spb.fs=500;
save('h_spb.mat','-struct','h_spb', '-v7.3');
clear

load('h_spb.mat')
size('h_spb.X')


%%% Video 2

fprintf('Aligning Highway Msk, Video 2...')
files=dir('h_msk*.mat');
subs={};
for i=1:length(files)
	load(files(i).name);
	subs{i}=h_msk;
	clear h_msk
end

H_msk=subs{1};
for i=2:length(subs)
	H_msk(:,:,i)=subs{i};
end

disp(size(H_msk))

h_msk.X=H_msk;
h_msk.fs=500;
save('h_msk.mat','-struct','h_msk', '-v7.3');
clear

load('h_msk.mat')
size('h_msk.X')


%%% Video 3

fprintf('Aligning Park Msk, Video 3...')
files=dir('p_msk*.mat');
subs={};
for i=1:length(files)
	load(files(i).name);
	subs{i}=p_msk;
	clear p_msk
end

P_msk=subs{1};
for i=2:length(subs)
	P_msk(:,:,i)=subs{i};
end

disp(size(P_msk))

p_msk.X=P_msk;
p_msk.fs=500;
save('p_msk.mat','-struct','p_msk', '-v7.3');
clear

load('p_msk.mat')
size('p_msk.X')


%%% Video 4

fprintf('Aligning Park Sbp, Video 4...')
files=dir('p_spb*.mat');
subs={};
for i=1:length(files)
	load(files(i).name);
	subs{i}=p_spb;
	clear p_spb
end

P_sbp=subs{1};
for i=2:length(subs)
	P_sbp(:,:,i)=subs{i};
end

disp(size(P_sbp))

p_spb.X=P_sbp;
p_spb.fs=500;
save('p_spb.mat','-struct','p_spb', '-v7.3');
clear

load('p_spb.mat')
size('p_spb.X')


%%% Video 5

fprintf('Aligning Boulevard Spb, Video 5...')
files=dir('b_spb*.mat');
subs={};
for i=1:length(files)
	load(files(i).name);
	subs{i}=b_spb;
	clear b_spb
end

B_spb=subs{1};
for i=2:length(subs)
	B_spb(:,:,i)=subs{i};
end

disp(size(B_spb))

b_spb.X=B_spb;
b_spb.fs=500;
save('b_spb.mat','-struct','b_spb', '-v7.3');
clear

load('b_spb.mat')
size('b_spb.X')


%%% Video 6

fprintf('Aligning Boulevard Msk, Video 6...')
files=dir('b_msk*.mat');
subs={};
for i=1:length(files)
	load(files(i).name);
	subs{i}=b_msk;
	clear b_msk
end

B_msk=subs{1};
for i=2:length(subs)
	B_msk(:,:,i)=subs{i};
end

disp(size(B_msk))

b_msk.X=B_msk;
b_msk.fs=500;
save('b_msk.mat','-struct','b_msk', '-v7.3');
clear

load('b_msk.mat')
size('b_msk.X')


%%% Video 7

fprintf('Aligning Sea, Video 7...')
files=dir('sea*.mat');
subs={};
for i=1:length(files)
	load(files(i).name);
	subs{i}=sea;
	clear sea
end

Sea=subs{1};
for i=2:length(subs)
	Sea(:,:,i)=subs{i};
end

disp(size(Sea))

sea.X=Sea;
sea.fs=500;
save('sea.mat','-struct','sea', '-v7.3');
clear

load('sea.mat')
size('sea.X')


%%% Video 8

fprintf('Aligning Blurred, Video 8...')
files=dir('blur*.mat');
subs={};
for i=1:length(files)
	load(files(i).name);
	subs{i}=blur;
	clear blur
end

Blur=subs{1};
for i=2:length(subs)
	Blur(:,:,i)=subs{i};
end

disp(size(Blur))

blur.X=Blur;
blur.fs=500;
save('blur.mat','-struct','blur', '-v7.3');
clear

load('blur.mat')
size('blur.X')


%%% Video 9

fprintf('Aligning Movie, Video 9...')
files=dir('mov*.mat');
subs={};
for i=1:length(files)
	load(files(i).name);
	subs{i}=mov;
	clear mov
end

Mov=subs{1};
for i=2:length(subs)
	Mov(:,:,i)=subs{i};
end

disp(size(Mov))

mov.X=Mov;
mov.fs=500;
save('mov.mat','-struct','mov', '-v7.3');
clear

load('mov.mat')
size('mov.X')