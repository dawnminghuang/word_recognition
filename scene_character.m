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


%%% ��ȡѵ��������
train.name=read_train(train_root,numberoftraindata,numberofclass);
train.feature=hog_encodeImage(train.name, ['train' encoding]) ;
% train.feature=SIFT_encodeImage(encoder,train.name, ['train' encoding]);

train_histograms=train.feature';
for i=1:62
    temp(:,i)=zeros(30,1)+i;
end
train_label=temp(:);
save('train_libsvm.mat','train_histograms','train_label');
%%% ��ȡ���Ե�����
test.name=read_test(test_root,numberoftestdata,numberofclass);
test.feature=hog_encodeImage(test.name, ['test' encoding]) ;
% test.feature=SIFT_encodeImage(encoder,test.name, ['test' encoding]) ;
test_histograms=test.feature';
for i=1:62
    temp1(:,i)=zeros(15,1)+i;
end
test_label=temp1(:);
save('test_libsvm.mat','test_histograms','test_label');



%%% libsvm ����

format compact;

%% ������ȡ
load('test_libsvm.mat')
load('train_libsvm.mat')

% ѡ��ѵ�����Ͳ��Լ�
train_data=double(train_histograms);

test_data=double(test_histograms);

%% ����Ԥ����
% ����Ԥ����,��ѵ�����Ͳ��Լ���һ����[0,1]����

[mtrain,ntrain] = size(train_data);
[mtest,ntest] = size(test_data);

dataset = [train_data;test_data];
% mapminmaxΪMATLAB�Դ��Ĺ�һ������
[dataset_scale,ps] = mapminmax(dataset',0,1);
dataset_scale = dataset_scale';
% dataset_scale=dataset;
train_data = dataset_scale(1:mtrain,:);
test_data = dataset_scale( (mtrain+1):(mtrain+mtest),: );
%% SVM����ѵ��
model = svmtrain(train_label, train_data, '-t 0 -c 0.2 -g 1');

%% SVM����Ԥ��
[predict_label,accuracy,prob_estimates1] = svmpredict(test_label, test_data, model);
% save('hog_decision.mat','prob_estimates1');
%% �������

% ���Լ���ʵ�ʷ����Ԥ�����ͼ
% ͨ��ͼ���Կ���ֻ��һ�����������Ǳ���ֵ�
figure;
hold on;
plot(test_label,'o');
plot(predict_label,'r*');
xlabel('testdata','FontSize',12);
ylabel('label','FontSize',12);
legend('testdata','predictlabel');
% title('���Լ���ʵ�ʷ����Ԥ�����ͼ','FontSize',12);
grid on;


