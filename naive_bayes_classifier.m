function [classified]=naive_bayes_classifier(S_hat,m_hat,c,l,array)

for i=1:c %Apply the appropriate normal pdf to every pixel
    for j=1:l
        perFeature(i,j,:)=normpdf(array(j,:),m_hat(i,j),sqrt(S_hat(i,j)));
    end
end

naive_probs = sum(perFeature,2); %Add (instead of multiply) the pdfs 
naive_probs = squeeze(naive_probs);

[~, indices]=max(naive_probs); %Choose the class that results to the highest value of the sum of the pdfs
classified=indices;