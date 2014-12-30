function [bbox,windows_img]=sliding_windows(windows_height,windows_width,word_img)
xlength=size(word_img,2)-windows_width;
x=1:1:xlength;
y=ones(xlength,1);
box=[x(:) y(:) x(:)+windows_width-1 y(:)+windows_height-1];
window={};
j=1;
for i=1:length(box)
        window{j}=cropbbox(word_img,box(i,:)); 
%         set(gcf, 'position', [0 0 200 200]);
%         figure();imshow(windows{j});
        j=j+1;
end
windows_img=window;
bbox=box;
end

