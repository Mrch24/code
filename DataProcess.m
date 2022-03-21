clear;clc;
load('ORL_32x32.mat');
 for n=1:1:40
     for m=1:9
     eval(['train',num2str(n),'_',num2str(m),'=','reshape(fea((n-1)*10+m,:),32,32)',';'])
     end
 end
for j=1:1:40
    eval(['test',num2str(j),'=','reshape(fea(10*j,:),32,32)',';'])
end