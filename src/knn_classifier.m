function [classified]=knn_classifier(c,k,train_set,train_set_response,test_set)

for i=1:size(test_set,2)
    for j=1:size(train_set,2) %Calculating the distances of a pixel of the test set from all the training pixels
        distance(j) = (test_set(1,i) - train_set(1,j))* ...
        (test_set(1,i) - train_set(1,j)) + (test_set(2,i) - train_set(2,j))* ...
        (test_set(2,i) - train_set(2,j));
    end
    [val,sorted] = sort(distance); %Sorting the distances
    class_frequency = zeros(1,c);
    for j=1:k %Calculating the frequencies of each category from each of the closest k points
        class_frequency(train_set_response(sorted(j))) = class_frequency(train_set_response(sorted(j)))+1;
    end
    [val,classified(i)]=max(class_frequency); %Classify the pixel to the category with the highest frequency
end
