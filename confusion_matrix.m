function [confusion_matrix]=confusion_matrix(classified,Test_array_response)

confusion_matrix = zeros(5, 5);

errors = classified~=Test_array_response;
sum(errors)/length(classified);

for i=1:length(errors) %Creating the confusion matrix
    if(errors(i)==1)
        confusion_matrix(Test_array_response(i),classified(i)) = confusion_matrix(Test_array_response(i),classified(i)) + 1;
    else
        confusion_matrix(classified(i),classified(i)) = confusion_matrix(classified(i),classified(i)) + 1;
    end
end