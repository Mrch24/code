clear;clc;
load('ORL_32x32.mat');
for i=1:1:40
    eval(['train',num2str(i),'=','fea((i-1)*10+1:i*10-1,1:1024)','/255',';'])
end
for j=1:1:40
    eval(['test',num2str(j),'=','fea(10*j,1:1024)','/255',';'])
end
