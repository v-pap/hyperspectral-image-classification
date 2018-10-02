function [best_k]=calculate_best_k(Train_array_response,Train_array_pos,c)

random_indices = (crossvalind('Kfold', Train_array_response, 5))'; %Creating an array that randomly assigns each pixel to a set
                                                            %while keeping approximately the same number of classes in each set    
k_error = zeros(1,floor(17/2) + 1);

for i=1:5
    test_set = (Train_array_pos(find(random_indices == i),:))'; %Creating the sets
    test_set_response = (Train_array_response(:,find(random_indices == i)))';
    train_set = (Train_array_pos(find(random_indices ~= i),:))';
    train_set_response = (Train_array_response(:,find(random_indices ~= i)))';

    counter = 1;
    for k=1:2:17
        classified = knn_classifier(c,k,train_set,train_set_response,test_set); %Keeping the result of the classifier
        pr_err = sum(classified~=test_set_response')/length(test_set_response);
        k_error(counter) = k_error(counter) + pr_err; %and then updating the error of each k
        counter = counter + 1;
        X = ['k = ',num2str(k),' - pr_err = ', num2str(pr_err)];
        %disp(X);
    end
end

[~, index] = min(k_error(:));
best_k = (index * 2) - 1; %Calculating the best k