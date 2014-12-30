%%
%%% Change data name compate with label %%%
% train_root='.\synth\train\charHard';
% test_root='.\synth\test\charHard';
% change_name(test_root)

%%
%%% read word image  %%%
clc;
clear all;
[fn pn fi]=uigetfile('*.*','choose a picture');
word_img=imread([pn fn]);
windows_height=size(word_img,1);
scale=[1.25,1,0.5,0.25];
bbox=cell(size(scale,2),1);
windows_img=cell(size(scale,2),1);
%%
%%% multi-scale sliding windows  %%%
for i=1:length(scale)
   windows_width=scale(i)*windows_height;
  [bbox{i},windows_img{i}]=sliding_windows(windows_height,windows_width,word_img);
end

%%% trian and test windows  %%%
%% 训练SVM 模型
setup;
train_root='.\synth\train\charHard';
%train_root='.\bmp';
%test_root='.\bmp';
encoding='hog';
% encoding = 'bovw'  ;
% encoder = load(sprintf('data/encoder_%s.mat',encoding)) ;
numberoftraindata=30;
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
%save('train_libsvm.mat','train_histograms','train_label');
%format compact;
%load('train_libsvm.mat')
train_data=double(train_histograms);
model = svmtrain(train_label, train_data, '-t 0 -c 0.2 -g 1 -b 1');

%% SVM网络预测
[boxs,test_histogram]=getfeature(windows_img,bbox);
test_data=double(test_histogram);
test_label= random('Poisson',1:size(test_data,1),1,size(test_data,1))';
[predict_label,accuracy,prob_estimates1] = svmpredict(test_label, test_data, model,'-b 1');
% save('hog_decision.mat','prob_estimates1');
%%
overlap=0.3;
scores=max(prob_estimates1,[],2);
boxes=[boxs,scores];
pick=nms(boxes,overlap);
figure;imshow(word_img);
hold on;
showbbox(boxs((pick),:));
