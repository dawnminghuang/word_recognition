function [boxes,feature]=getfeature(windows_img,bbox)
 encoding='hog';
  for  i=1:length(windows_img) 
      wl=length(windows_img{i}); 
      boxes((i-1)*wl+1:i*wl,:)=bbox{i};
      for j=1:wl
         
          feature((i-1)*wl+j,:)=hog_encodeImage(single(imresize(windows_img{i}{j},[48 48])),['train' encoding])';
      end
  end
end