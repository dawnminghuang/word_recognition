function  []=change_name(root)
% ni为读取图片张数，n为文件夹数目
%========读取负样本的图片========%
out_Files = dir(root);%展开，out_Files存储64个文件名包括.,..。
ti=0;
imglist=cell(0);
%========按temp的要求读取文件数========%
for i = 1:length(out_Files);
    if strcmp(out_Files(i).name,'.')|| strcmp(out_Files(i).name,'..')
    else
        rootpath=strcat(root,'/',out_Files(i).name);%因为i=1.2 的时候是.和..所以要-2然后在加上2
        in_filelist=dir(rootpath);
        ti=ti+1;
        for j=1:length(in_filelist)
            if strcmp(in_filelist(j).name,'.')|| strcmp(in_filelist(j).name,'..')|| strcmp(in_filelist(j).name,'Desktop_1.ini')|| strcmp(in_filelist(j).name,'Desktop_2.ini')||strcmp(in_filelist(j).name,'fids.dat')
                
            else
                
                temp=imread(strcat(rootpath,'/',in_filelist(j).name));
                imwrite(temp,strcat(rootpath,'/',num2str(ti),in_filelist(j).name))
                delete(strcat(rootpath,'/',in_filelist(j).name));
            end
        end
    end
end
end

