function [number] = read_train(root,ni,n)
% niΪ��ȡͼƬ������nΪ�ļ�����Ŀ
%========��ȡ��������ͼƬ========%
out_Files = dir(root);%չ����out_Files�洢64���ļ�������.,..��
tempind=0;
imglist=cell(0);
%========��temp��Ҫ���ȡ�ļ���========%
for i = 1:n+2;
    if strcmp(out_Files(i).name,'.')|| strcmp(out_Files(i).name,'..')
    else
        rootpath=strcat(root,'/',out_Files(i).name);%��Ϊi=1.2 ��ʱ����.��..����Ҫ-2Ȼ���ڼ���2
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

