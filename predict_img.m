function [all_face_pred, resized_img, num2name] = predict_img(img, rotation, models, num2name)
% input: an image object
% output:
% all_face_pred - each row contains prediction for a face. first 4 element
% of the row contains facebox info, 5th element of a row contains the
% prediction as number. If no face detected in input image then
% all_face_pred is an empty array

model = models{3,1}; %using the third model of the models array, this is the model with highest accuracy as models is sorted according to accuracy 


% detect, crop and resize face portion
img = imrotate(img, rotation);
[faces, face_boxes, resized_img] = get_faces(img);

% make prediction
all_face_pred = [];

if length(faces) == 0
%     disp('no face detected in input image');
    return;
else
    for i = 1:length(faces)
        % get face
        face = faces{i};
        face_box = face_boxes(i,:);
        % convert to feature vector
        x_test = double(img_to_X(face));
        
        % prediction
        pred = predict(model, x_test);
        all_face_pred = [all_face_pred; face_box, pred];
    end
end

end

