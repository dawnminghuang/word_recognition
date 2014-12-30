function [out] = read_image(root,number,amount)
%===================读取正样本的图片=================
%就只是一个文件夹下，number为其label
out=cell(0);
out_Files = dir(root);%展开，out_Files存储64个文件名包括.,..。
rootpath=strcat(root,'/',out_Files(number+2).name);%因为i=1.2 的时候是.和..所以要加上2
content=dir(rootpath);%返回M*1结构集
names = {content.name} ;
ok = regexpi(names, '.*\.(jpg|png|jpeg|gif|bmp|tiff)$', 'start') ;%正则表达式进行匹配,返回匹配的开始位置
names = names(~cellfun(@isempty,ok)) ;
for i = 1:amount
    out{i} = fullfile(rootpath,names{i}) ;
end

end


