clear all;

%% constants
IMG_FORMATS = ["jpg", "JPG", "JPEG", "jpeg", "gif", "png"]; %only images of this format will be kept, other format images will be rejected

% FROM FOLDER
dataset_dir = "./extra_ph";
% TO FOLDER
cr_ds_dir = "./cr_joba"; % cropped faces dataset directory

%% creating cropped faces dataset
people_names = dir(dataset_dir);

for i = 3:length(people_names)
    disp(i-2);

    count = 100; % count of how many photos of the person have been cropped and saved
    name = people_names(i).name; % name of the person
    mkdir(cr_ds_dir + "/" + name);
    
    person = dataset_dir + "/" + string(people_names(i).name);
    photo_files = dir(person); % array of struct containing photo file infos
   

    %looping through photo_files struct to read every photo
    for j = 3:length(photo_files)
        photo_dir = person + "/" + string(photo_files(j).name);
        ext = strsplit(photo_dir, '.');
        ext = ext(end); % extension of the image file

        if ismember(ext, IMG_FORMATS)
            % get cropped face image and write it to proper folder
            img = imread(photo_dir);
            img_faces = get_faces(img);

            for k = 1:length(img_faces)
                write_dir = cr_ds_dir + "/" + name + "/" + name + count + ".jpg";
                imwrite(img_faces{k}, write_dir);
                count = count + 1;
            end
        else
            disp("unsupported file format " + string(ext) + " ignored");
        end
    end
end

