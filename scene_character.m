clc;
clear all;
close all;
setup;
%train_root='.\synth\train\charHard';
train_root='.\bmp';

test_root='.\synth\test\charHard';
%test_root='.\bmp';
encoding='hog';
% encoding = 'bovw'  ;
% encoder = load(sprintf('data/encoder_%s.mat',encoding)) ;
numberoftraindata=30;
numberoftestdata=15;
numberofclass=62;


%%% 获取训练的数据
train.name=read_train(train_root,numberoftraindata,numberofclass);
train.feature=hog_encodeImage(train.name, ['train' encoding]) ;
% train.feature=SIFT_encodeImage(encoder,train.name, ['train' encoding]);

train_histograms=train.feature';
for i=1:62
    temp(:,i)=zeros(30,1)+i;
end
train_label=temp(:);
save('train_libsvm.mat','train_histograms','train_label');
%%% 获取测试的数据
test.name=read_test(test_root,numberoftestdata,numberofclass);
test.feature=hog_encodeImage(test.name, ['test' encoding]) ;
% test.feature=SIFT_encodeImage(encoder,test.name, ['test' encoding]) ;
test_histograms=test.feature';
for i=1:62
    temp1(:,i)=zeros(15,1)+i;
end
test_label=temp1(:);
save('test_libsvm.mat','test_histograms','test_label');



%%% libsvm 测试

format compact;

%% 数据提取
load('test_libsvm.mat')
load('train_libsvm.mat')

% 选定训练集和测试集
train_data=double(train_histograms);

test_data=double(test_histograms);

%% 数据预处理
% 数据预处理,将训练集和测试集归一化到[0,1]区间

[mtrain,ntrain] = size(train_data);
[mtest,ntest] = size(test_data);

dataset = [train_data;test_data];
% mapminmax为MATLAB自带的归一化函数
[dataset_scale,ps] = mapminmax(dataset',0,1);
dataset_scale = dataset_scale';
% dataset_scale=dataset;
train_data = dataset_scale(1:mtrain,:);
test_data = dataset_scale( (mtrain+1):(mtrain+mtest),: );
%% SVM网络训练
model = svmtrain(train_label, train_data, '-t 0 -c 0.2 -g 1');

%% SVM网络预测
[predict_label,accuracy,prob_estimates1] = svmpredict(test_label, test_data, model);
% save('hog_decision.mat','prob_estimates1');
%% 结果分析

% 测试集的实际分类和预测分类图
% 通过图可以看出只有一个测试样本是被错分的
figure;
hold on;
plot(test_label,'o');
plot(predict_label,'r*');
xlabel('testdata','FontSize',12);
ylabel('label','FontSize',12);
legend('testdata','predictlabel');
% title('测试集的实际分类和预测分类图','FontSize',12);
grid on;


