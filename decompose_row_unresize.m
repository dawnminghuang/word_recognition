function [bw_sub,gs_sub ] = decompose_row_unresize(Img)

%%%%%%�ָ�õ���ͼ��ֱ���̫�ͣ��ȶ�ͼ������������Բ�ֵ


%%%%%%��ֵ��
[~,~,c]=size(Img);
if  c==1
    bw= ~im2bw(Img,graythresh(Img));
else
    Img=rgb2gray(Img);
    bw= ~im2bw(Img,graythresh(Img));
end

%%%%%%%ȥ���ı�
bwl=bwareaopen(bw,250);

%%%%%%%ȥ����
bwo=bw-bwl;

%%%%%%%%�ָ���

%%%%%%%%%%ͶӰ������
[y,x]=size(bwo);
Y_touying=sum(bwo,2);
%%%%%%%%%%%%%%%%%%%%���ַָ�
k1=1;
sor=unique(Y_touying);
limit=median(sor(1:2));
for h=1:y-1      %xΪ����
    if  (Y_touying(h,1)<=limit)&&(Y_touying(h+1,1)>limit)
        fenge(1,k1)=h;
        k1=k1+1;
    elseif (Y_touying(h,1)>=limit)&&(Y_touying(h+1,1)<limit)
        fenge(1,k1)=h+1;
        k1=k1+1;
    end
end
k1=k1-1;
%%%%%%%%%%%%%%%%��ʾ�ָ�ͼ����������
bw_sub=cell(1,k1/2);
gs_sub=cell(1,k1/2);
for s=1:2:k1-1
     bw_sub{1,(s+1)/2}=bwo(fenge(s):fenge(s+1),1:x);
     gs_sub{1,(s+1)/2}=Img(fenge(s):fenge(s+1),1:x);
%      subplot(k1/2,1,(s+1)/2);imshow(Img(fenge(s):fenge(s+1),1:x));
end


end

