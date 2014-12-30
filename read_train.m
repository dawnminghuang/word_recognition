function [number] = read_train(root,ni,n)
% ni为读取图片张数，n为文件夹数目
%========读取负样本的图片========%
out_Files = dir(root);%展开，out_Files存储64个文件名包括.,..。
tempind=0;
imglist=cell(0);
%========按temp的要求读取文件数========%
for i = 1:n+2;
    if strcmp(out_Files(i).name,'.')|| strcmp(out_Files(i).name,'..')
    else
        rootpath=strcat(root,'/',out_Files(i).name);%因为i=1.2 的时候是.和..所以要-2然后在加上2
        in_filelist=dir(rootpath);
       
        for j=1:ni+2
            if strcmp(in_filelist(j).name,'.')|| strcmp(in_filelist(j).name,'..')|| strcmp(in_filelist(j).name,'Desktop_1.ini')|| strcmp(in_filelist(j).name,'Desktop_2.ini')||strcmp(in_filelist(j).name,'fids.dat')
                
            else
                tempind=tempind+1;
                imglist{tempind}=strcat(rootpath,'/',in_filelist(j).name);
            end
        end
    end
end
number=imglist;

end

