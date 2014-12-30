function [bw_sub,gs_sub ] = decompose_row_unresize(Img)

%%%%%%分割得到的图像分辨率太低，先对图像进行三次线性插值


%%%%%%二值化
[~,~,c]=size(Img);
if  c==1
    bw= ~im2bw(Img,graythresh(Img));
else
    Img=rgb2gray(Img);
    bw= ~im2bw(Img,graythresh(Img));
end

%%%%%%%去除文本
bwl=bwareaopen(bw,250);

%%%%%%%去除线
bwo=bw-bwl;

%%%%%%%%分割行

%%%%%%%%%%投影分离行
[y,x]=size(bwo);
Y_touying=sum(bwo,2);
%%%%%%%%%%%%%%%%%%%%文字分割
k1=1;
sor=unique(Y_touying);
limit=median(sor(1:2));
for h=1:y-1      %x为列数
    if  (Y_touying(h,1)<=limit)&&(Y_touying(h+1,1)>limit)
        fenge(1,k1)=h;
        k1=k1+1;
    elseif (Y_touying(h,1)>=limit)&&(Y_touying(h+1,1)<limit)
        fenge(1,k1)=h+1;
        k1=k1+1;
    end
end
k1=k1-1;
%%%%%%%%%%%%%%%%显示分割图像结果并保存
bw_sub=cell(1,k1/2);
gs_sub=cell(1,k1/2);
for s=1:2:k1-1
     bw_sub{1,(s+1)/2}=bwo(fenge(s):fenge(s+1),1:x);
     gs_sub{1,(s+1)/2}=Img(fenge(s):fenge(s+1),1:x);
%      subplot(k1/2,1,(s+1)/2);imshow(Img(fenge(s):fenge(s+1),1:x));
end


end

