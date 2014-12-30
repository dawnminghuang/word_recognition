clc;
close all;
clear all;
setup;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%Scanning window character detection%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%% load test image
imgpath='E:\Matlabdip\low_quality_recognition\nlost';
imgfname='e5.bmp';
Img=imread([imgpath '\' imgfname]);

sub=split_row(Img);
img=sub{4};

%%%%%%%%%%%%%%% decompose the image into sub-windows
[ysz,xsz]=size(img);
wxsz=16; wysz=ysz;    %´°¿ÚµÄ³¤wxsz£¬¿íwysz.
x=1:1:xsz;
xlength=size(x,2);
y=ones(xlength,1);
bbox_all=[x(:) ones(xlength,1) x(:)+wxsz-1 y(:)+wysz-1];

% remove sub_windows which don't contain any data 
windows={};
j=1;
for i=1:size(bbox_all,1)
    if sum(sum(cropbbox(img,bbox_all(i,:))))
        imgcropall(:,:,j)=cropbbox(img,bbox_all(i,:));
        bbox(j,:)=bbox_all(i,:);
        windows(j)={imgcropall(:,:,j)}; 
%         set(gcf, 'position', [0 0 200 200]);
%         figure();imshow(windows{j});
       
        j=j+1;
    end
end
[maxScore,label]=scanning_recognize_pixel(windows);
n1=size(bbox,1);
[~,index]=sort(maxScore);
figure;
w_size=size(index,2);
for i=1:100
    subplot(10,10,i);imshow(windows{index(w_size-i)});
end

