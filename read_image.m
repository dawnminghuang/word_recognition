function [out] = read_image(root,number,amount)
%===================��ȡ��������ͼƬ=================
%��ֻ��һ���ļ����£�numberΪ��label
out=cell(0);
out_Files = dir(root);%չ����out_Files�洢64���ļ�������.,..��
rootpath=strcat(root,'/',out_Files(number+2).name);%��Ϊi=1.2 ��ʱ����.��..����Ҫ����2
content=dir(rootpath);%����M*1�ṹ��
names = {content.name} ;
ok = regexpi(names, '.*\.(jpg|png|jpeg|gif|bmp|tiff)$', 'start') ;%������ʽ����ƥ��,����ƥ��Ŀ�ʼλ��
names = names(~cellfun(@isempty,ok)) ;
for i = 1:amount
    out{i} = fullfile(rootpath,names{i}) ;
end

end


