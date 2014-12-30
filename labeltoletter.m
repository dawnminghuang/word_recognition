function [ strout ] = labeltoletter( label)
%把标签转化成字符
cout=1;
for i=1:size(label,2)
    if label(i)>=1&&label(i)<=10
        strout{cout}=num2str(label(i)+47);
        cout=cout+1;
        fprintf('%c',label(i)+47)
    elseif label(i)>10&&label(i)<=36
        strout{cout}=num2str(label(i)+54);
        cout=cout+1;
        fprintf('%c',label(i)+54)
    elseif label(i)>36&&label(i)<=62
        strout{cout}=num2str(label(i)+60);
        cout=cout+1;
        fprintf('%c',label(i)+60)
    end
end

