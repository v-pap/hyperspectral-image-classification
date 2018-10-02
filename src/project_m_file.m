clear
format compact
close all

load ../dataset/Salinas_hyperspectral.mat %Load the Salinas hypercube called "Salinas_Image"
[p,n,l]=size(Salinas_Image) % p,n define the spatial resolution of the image, while l is the number of bands (number of features for each pixel)
c = 5; %number of classes

load ../dataset/classification_labels.mat
% This file contains three arrays of dimension 22500x1 each, called
% "Training_Set", "Test_Set" and "Operational_Set". In order to bring them
% in an 150x150 image format we use the command "reshape" as follows:
Training_Set_Image=reshape(Training_Set, p,n); % In our case p=n=150 (spatial dimensions of the Salinas image).
Test_Set_Image=reshape(Test_Set, p,n);
Operational_Set_Image=reshape(Operational_Set, p,n);

%Depicting the various bands of the Salinas image
%for i=1:l
    %figure(1), imagesc(Salinas_Image(:,:,i))
    %pause(0.05) % This command freezes figure(1) for 0.05sec. 
%end

% Depicting the training, test and operational sets of pixels (for the
% pixels depicted with a dark blue color, the class label is not known.
% Each one of the other colors in the following figures indicate a class).
%figure(2), imagesc(Training_Set_Image)
%figure(3), imagesc(Test_Set_Image)
%figure(4), imagesc(Operational_Set_Image)

% Constructing the 204xN array whose columns are the vectors corresponding to the
% N vectors (pixels) of the training set (similar codes cane be used for
% the test and the operational sets).
Train=zeros(p,n,l); % This is a 3-dim array, which will contain nonzero values only for the training pixels
Test=zeros(p,n,l); % This is a 3-dim array, which will contain nonzero values only for the test pixels
Operational=zeros(p,n,l); % This is a 3-dim array, which will contain nonzero values only for the operational pixels
for i=1:l
     %Multiply elementwise each band of the Salinas_Image with the mask 
     % "Training_Set_Image>0", which identifies only the training vectors.
    Train(:,:,i)=Salinas_Image(:,:,i).*(Training_Set_Image>0);
    Test(:,:,i)=Salinas_Image(:,:,i).*(Test_Set_Image>0);
    Operational(:,:,i)=Salinas_Image(:,:,i).*(Operational_Set_Image>0);
    %figure(5), imagesc(Train(:,:,i)) % Depict the training set per band
    %pause(0.05)
end

Train_array=[]; %This is the wanted 204xN array
Train_array_response=[]; % This vector keeps the label of each of the training pixels
Train_array_pos=[]; % This array keeps (in its rows) the position of the training pixels in the image.
Test_array=[]; %This is the wanted 204xN array
Test_array_response=[]; % This vector keeps the label of each of the training pixels
Test_array_pos=[]; % This array keeps (in its rows) the position of the training pixels in the image.
Operational_array=[]; %This is the wanted 204xN array
Operational_array_response=[]; % This vector keeps the label of each of the training pixels
Operational_array_pos=[]; % This array keeps (in its rows) the position of the training pixels in the image.
for i=1:p
    for j=1:n
        if(Training_Set_Image(i,j)>0) %Check if the (i,j) pixel is a training pixel
            Train_array=[Train_array squeeze(Train(i,j,:))];
            Train_array_response=[Train_array_response Training_Set_Image(i,j)];
            Train_array_pos=[Train_array_pos; i j];
        end
        if(Test_Set_Image(i,j)>0) %Check if the (i,j) pixel is a test pixel
            Test_array=[Test_array squeeze(Test(i,j,:))];
            Test_array_response=[Test_array_response Test_Set_Image(i,j)];
            Test_array_pos=[Test_array_pos; i j];
        end
        if(Operational_Set_Image(i,j)>0) %Check if the (i,j) pixel is a operational pixel
            Operational_array=[Operational_array squeeze(Operational(i,j,:))];
            Operational_array_response=[Operational_array_response Operational_Set_Image(i,j)];
            Operational_array_pos=[Operational_array_pos; i j];
        end
    end
end

Combined_array = [Train_array Test_array Operational_array];
Combined_array_response = [Train_array_response Test_array_response Operational_array_response];
Combined_array_pos = [Train_array_pos' Test_array_pos' Operational_array_pos'];
Combined_array_pos = Combined_array_pos';

for i=1:c %Calculate the ì, ó of every spectral band (out of the 204) of a class 
    for j=1:l
        [m_hat(i,j), S_hat(i,j)]=Gaussian_ML_estimate(Train_array(j,find(Train_array_response==i)));
    end
end

disp('Naive Bayes Classifier')

classified = naive_bayes_classifier(S_hat,m_hat,c,l,Test_array);

confusion_matrix = confusion_matrix(classified,Test_array_response)

trace(confusion_matrix)/sum(sum(confusion_matrix)) %accuracy

clear perFeature;
clear naive_probs;
clear indices;
clear max;

classified = naive_bayes_classifier(S_hat,m_hat,c,l,Combined_array);

Result_Set_Image = zeros(p,n); %Creating the picture
for i=1:length(Combined_array_pos)
    Result_Set_Image(Combined_array_pos(i,1),Combined_array_pos(i,2)) = classified(1,i);
end


figure('Name','Naive Bayes Classifier'); imagesc(Result_Set_Image);

clear classified;
clear confusion_matrix;

disp('Euclidean Classifier')

classified = euclidean_classifier(m_hat,c,Test_array);

confusion_matrix = confusion_matrix(classified,Test_array_response)

trace(confusion_matrix)/sum(sum(confusion_matrix)) %accuracy

clear classified;
clear distance;

classified = euclidean_classifier(m_hat,c,Combined_array);

Result_Set_Image = zeros(p,n);
for i=1:length(Combined_array_pos) %Creating the picture
    Result_Set_Image(Combined_array_pos(i,1),Combined_array_pos(i,2)) = classified(1,i);
end

figure('Name','Euclidean Classifier'); imagesc(Result_Set_Image);

clear confusion_matrix;
clear classified;

disp('KNN Classifier')

best_k = calculate_best_k(Train_array_response,Train_array_pos,c)

classified = knn_classifier(c,best_k,Train_array_pos',Train_array_response,Test_array_pos'); %Doing the KNN classification on the test set
pr_err = sum(classified~=Test_array_response)/length(Test_array_response);

confusion_matrix = confusion_matrix(classified,Test_array_response)

trace(confusion_matrix)/sum(sum(confusion_matrix)) %accuracy

clear classified;
classified = knn_classifier(c,best_k,Train_array_pos',Train_array_response,Combined_array_pos'); %Doing the KNN classification on the combined set

Result_Set_Image = zeros(p,n);
for i=1:length(Combined_array_pos) %Creating the picture
    Result_Set_Image(Combined_array_pos(i,1),Combined_array_pos(i,2)) = classified(1,i);
end

figure('Name','KNN Classifier'); imagesc(Result_Set_Image);


Result_Set_Image = zeros(p,n);%Creating the picture which combines all 3 sets
for i=1:length(Test_array_pos)
    Result_Set_Image(Test_array_pos(i,1),Test_array_pos(i,2)) = Test_array_response(1,i);
end
for i=1:length(Train_array_pos)
    Result_Set_Image(Train_array_pos(i,1),Train_array_pos(i,2)) = Train_array_response(1,i);
end
for i=1:length(Operational_array_pos)
    Result_Set_Image(Operational_array_pos(i,1),Operational_array_pos(i,2)) = Operational_array_response(1,i);
end

figure('Name','Combined Set'); imagesc(Result_Set_Image);
        
