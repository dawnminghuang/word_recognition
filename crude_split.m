function [all,all_color] = crude_split(sub,colorImage)
% 粗分割，输入为众多行中某行，输出为单个和粘连的
%%
bw=sub;
[y,x]=size(bw);
X_touying=sum((bw));
%%
%=================粗分割=============================
k1=1;limit=3;
for h=1:x-1%x为列数
    if  (X_touying(1,h)<=limit)&&(X_touying(1,h+1)>limit)
        fenge(1,k1)=h;
        k1=k1+1;
    elseif (X_touying(1,h)>limit)&&(X_touying(1,h+1)<=limit)
        fenge(1,k1)=h+1;
        k1=k1+1;
    end
end
k1=k1-1;
%%
%=================保存粗分割结果于all=========================%
all=cell(1,k1/2);
all_color=cell(1,k1/2);
figure;imshow(sub);
for i=1:k1/2
    rectangle('Position',[fenge((i-1)*2+1),1,fenge(i*2)-fenge((i-1)*2+1),y], 'EdgeColor','g');
    all{i}=sub(1:y,fenge((i-1)*2+1):fenge(i*2));
    set(gca,'position',[0,0,1,1])
end
figure;imshow(colorImage);
for i=1:k1/2
    rectangle('Position',[fenge((i-1)*2+1),1,fenge(i*2)-fenge((i-1)*2+1),y], 'EdgeColor','g');
    all_color{i}=colorImage(1:y,fenge((i-1)*2+1):fenge(i*2),:);
    set(gca,'position',[0,0,1,1])
end
