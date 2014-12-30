for i=1:size(testScores,1)
    score(i)=find(testScores(i,:)==max(testScores(i,:))); 
end
 put=labeltoletter(score);
figure;
for i=1:size(finalone,2)
   subplot(4,5,i); imshow(finalone{i});
end