function  []=change_name(root)
% niΪ��ȡͼƬ������nΪ�ļ�����Ŀ
%========��ȡ��������ͼƬ========%
out_Files = dir(root);%չ����out_Files�洢64���ļ�������.,..��
ti=0;
imglist=cell(0);
%========��temp��Ҫ���ȡ�ļ���========%
for i = 1:length(out_Files);
    if strcmp(out_Files(i).name,'.')|| strcmp(out_Files(i).name,'..')
    else
        rootpath=strcat(root,'/',out_Files(i).name);%��Ϊi=1.2 ��ʱ����.��..����Ҫ-2Ȼ���ڼ���2
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

