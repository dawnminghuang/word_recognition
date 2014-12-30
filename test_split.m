
clc;
clear all;
[fn pn fi]=uigetfile('*.*','choose a picture');
colorImage=imread([pn fn]);
grayImage = rgb2gray(colorImage);
[x,y]=size(grayImage);
mserRegions = detectMSERFeatures(grayImage, 'RegionAreaRange' ,[30 floor(0.3*x*y)]);
mserRegionsPixels = vertcat(cell2mat(mserRegions.PixelList));


%%
%��mser���������ϵ��ȡ������Ȼ����Ӧϵ���ĵط���ֵΪ�档ȡ��mser����
mserMask = false(size(grayImage));
ind = sub2ind(size(mserMask), mserRegionsPixels(:,2), mserRegionsPixels(:,1));
mserMask(ind) = true;
figure; imshow(mserMask);
% word_img=imread([pn fn]);
% sub=im2bw(word_img,graythresh(word_img));
[all,all_color] = crude_split(mserMask,colorImage);