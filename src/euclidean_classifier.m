function [classified]=euclidean_classifier(m_hat,c,array)

for i=1:size(array,2)
    for j=1:c %Calculating the sum of distances between a pixel and the spectral band medians of each class
        distance(j)=(array(:,i)-(m_hat(j,:))')'*(array(:,i)-(m_hat(j,:))');
    end
    [~,classified(i)]=min(distance); %Assigning the pixel to the class with the minimum sum
end
