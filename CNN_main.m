%% 程序说明
%          1、池化（pooling）采用平均2*2
%          2、网络结点数说明：
%                           输入层：32*32
%                           第一层：28*28（卷积）*20
%                           tanh
%                           第二层：14*14（pooling）*20
%                           第三层：40(全连接)
%                           第四层：40(softmax)
%          3、网络训练部分采用360个样本，检验部分采用40个样本
clear all;clc;
load('data_all.mat');
%% 网络初始化
layer_c1_num=20;
layer_f1_num=40;
layer_output_num=40;
%权值调整步进
yita=0.01;

% %bias初始化
% bias_c1=(2*rand(1,layer_c1_num)-ones(1,layer_c1_num))/sqrt(layer_c1_num);
% bias_f1=(2*rand(1,layer_f1_num)-ones(1,layer_f1_num))/sqrt(layer_f1_num);
% %卷积核初始化
% [kernel_c1,kernel_f1]=init_kernel(layer_c1_num,layer_f1_num);
% %pooling核初始化
% pooling_a=ones(2,2)/4;
% %全连接层的权值
% weight_f1=(2*rand(layer_s1_num,layer_output_num)-ones(layer_s1_num,layer_output_num))/sqrt(layer_s1_num);
% weight_output=(2*rand(layer_output_num,layer_f1_num)-ones(layer_output_num,layer_f1_num))/sqrt(layer_output_num);

load('Pre_57t_35.mat');

disp('网络初始化完成......');
preserve_bias_c1=bias_c1;
preserve_bias_f1=bias_f1;
preserve_kernel_c1=kernel_c1;
preserve_kernel_f1=kernel_f1;
preserve_pooling_a=pooling_a;
preserve_weight_f1=weight_f1;
preserve_weight_output=weight_output;
%% 开始网络训练
disp('开始网络训练......');
for iter=1:57
for m=1:9
    for n=1:40
        %读取样本
        eval(['train_data','=','train',num2str(n),'_',num2str(m),'/255;'])        
        train_data=double(train_data);
        %前向传递,进入卷积层1
        for k=1:layer_c1_num
            state_c1(:,:,k)=convolution(train_data,kernel_c1(:,:,k));
            %进入激励函数
            state_c1(:,:,k)=tanh(state_c1(:,:,k)+bias_c1(1,k));
            %进入pooling1
            state_s1(:,:,k)=pooling(state_c1(:,:,k),pooling_a);
        end
        %进入f1层
        [state_f1_pre,state_f1_temp]=convolution_f1(state_s1,kernel_f1,weight_f1);
        %进入激励函数
        for nn=1:layer_f1_num
            state_f1(1,nn)=tanh(state_f1_pre(:,:,nn)+bias_f1(1,nn));
        end
        %进入softmax层
        for nn=1:layer_output_num
            output(1,nn)=exp(state_f1*weight_output(:,nn))/sum(exp(state_f1*weight_output));
        end
       %画图部分
       pout=train_data;
       pout_convolution = imadjust(state_c1(:,:,1));
       pout_polling = imadjust(state_s1(:,:,1));
       montage({pout,pout_convolution,pout_polling},'Size',[1 3]);
       title("原图像及卷积、pooling操作后对比");
       % 误差计算部分
        Error_cost=-output(1,n);
%           if (Error_cost<-0.99)
%               break;
%           end
        % 参数调整部分
        [kernel_c1,kernel_f1,weight_f1,weight_output,bias_c1,bias_f1]=CNN_upweight(yita,Error_cost,n,train_data,...
                                                                                                state_c1,state_s1,...
                                                                                                state_f1,state_f1_temp,...
                                                                                                output,...
                                                                                                kernel_c1,kernel_f1,weight_f1,weight_output,bias_c1,bias_f1);
    end    
end
end
disp('网络训练完成，开始检验......');
%%  检验
% result_bias_c1=bias_c1;
% result_bias_f1=bias_f1;
% result_kernel_c1=kernel_c1;
% result_kernel_f1=kernel_f1;
% result_pooling_a=pooling_a;
% result_weight_f1=weight_f1;
% result_weight_output=weight_output;
load('result_35.mat');
count=0;
for n=1:40
        m=10;
        %读取样本
        eval(['test_data','=','test',num2str(n),'/255;'])
        test_data=double(test_data);
        

        %前向传递,进入卷积层1
%         layer_name1='fold';
%         layer_name2='tanh';
%         layer_name3='pooling';
        for k=1:layer_c1_num
            state_c1(:,:,k)=convolution(test_data,kernel_c1(:,:,k));            
            %进入激励函数
            state_c1(:,:,k)=tanh(state_c1(:,:,k)+bias_c1(1,k));
            %进入pooling1
            state_s1(:,:,k)=pooling(state_c1(:,:,k),pooling_a);
        end        
%         imgsave(state_c1(:,:,1),n,layer_name1);
%         imgsave(state_s1(:,:,1),n,layer_name3);
        %进入f1层
        [state_f1_pre,state_f1_temp]=convolution_f1(state_s1,kernel_f1,weight_f1);
        %进入激励函数
        for nn=1:layer_f1_num
            state_f1(1,nn)=tanh(state_f1_pre(:,:,nn)+bias_f1(1,nn));
        end
        %进入softmax层
        for nn=1:layer_output_num
            output(1,nn)=exp(state_f1*weight_output(:,nn))/sum(exp(state_f1*weight_output));
        end
        [p,classify]=max(output);
        if (classify==n)
            count=count+1;
        end
        %画图部分
       pout=test_data;
       pout_convolution = imadjust(state_c1(:,:,1));
       pout_polling = imadjust(state_s1(:,:,1));
       montage({pout,pout_convolution,pout_polling},'Size',[1 3]);
       title("原图像及卷积、pooling操作后对比");
        
       fprintf('这是%d的图片,网络标记为%d,概率值为%d \n',n,classify,p);
       
 end