clear all;

%% create X, Y
clear all;
X = [];
Y = [];
num2name = []; % num2name - holds a mapping between row number and person's name

% feature engineering using wavelet transformation

IMG_FORMATS = ["jpg", "jpeg", "gif", "png"]; %only images of this format will be kept, other format images will be rejected
dataset_dir = "./cr_dataset";
% cr_ds_dir = "./cr_dataset"; % cropped faces dataset directory

people_names = dir(dataset_dir);

for i = 3:length(people_names)
%     count = 1; % count of how many photos of the person have been cropped and saved
    name = people_names(i).name; % name of the person
%     mkdir(cr_ds_dir + "/" + name);

    % num2name variable - holds a mapping between number and person's name
    num2name = [num2name; string(strrep(name,'_', ' '))];
    
    person = dataset_dir + "/" + string(people_names(i).name);
    photo_files = dir(person); % array of struct containing photo file infos
    
    %looping through photo_files struct to read every photo
    for j = 3:length(photo_files)
        photo_dir = person + "/" + string(photo_files(j).name);
        ext = strsplit(photo_dir, '.');
        ext = ext(end); % extension of the image file

        if ismember(ext, IMG_FORMATS)                 
            % process the photo and add to X
            img = imread(photo_dir);
            
            stacked_img = img_to_X(img);
            X = [X; stacked_img];
            Y = [Y; i-2];
            X = double(X);
            Y = double(Y);
        end
    end
end

save 'XY' X Y num2name; 

%% load X Y
XY_file = load('XY.mat');
X = XY_file.X;
Y = XY_file.Y;
num2name = XY_file.num2name;

%% create models using fitcecoc function
%% svm
disp('training model svm');
[Mdl_svm, accuracy_svm, pred, true] = get_model(X, Y, templateSVM('KernelFunction', 'gaussian' ), 0.2);
accuracy_svm

fig_svm = figure('Name', 'SVM');
figure(fig_svm)
confusionchart(true, pred);

%% knn
disp('training model knn');
[Mdl_knn, accuracy_knn, pred, true] = get_model(X, Y, templateKNN(), 0.2);
accuracy_knn

fig_knn = figure('Name', 'KNN');
figure(fig_knn);
confusionchart(true, pred);

%% discriminant
disp('training model discriminant')
[Mdl_discr, accuracy_discr, pred, true] = get_model(X, Y, templateDiscriminant(), 0.2);
accuracy_discr

fig_discr = figure('Name', 'discriminant');
figure(fig_discr);
confusionchart(true, pred);

%% save the model and number to name mapping variable
% models - cell array for storing all trained models and their accuracies
models = {Mdl_svm, accuracy_svm; Mdl_knn, accuracy_knn; Mdl_discr, accuracy_discr};
models = sortrows(models, 2); % sort the models according to accuracies
save 'models' models num2name;
