clear all; close all;

% take image for predicting
[file, path] = uigetfile({'*.*'});

if isequal(file, 0)
    disp('cancelled');
    return;
else
    try
        img = imread(string(path) + string(file));
    catch
        disp('invalid file format');
        return;
    end
end

% need rotation?
% in = input('does your photo need rotation?(0/1): ');
% if in == 1
%     rot = input('counterclockwise rotation needed in degrees: ');
% else
%     rot = 0;
% end
rot = 0;

% predicting
mdl_file = load('models.mat');
models = mdl_file.models; 
num2name = mdl_file.num2name;
% faceDetector = vision.CascadeObjectDetector('FrontalFaceCART');
% EyeDetector = vision.CascadeObjectDetector('EyePairSmall');
% NoseDetector = vision.CascadeObjectDetector('Nose');

[all_face_pred, resized_img, num2name] = predict_img(img, rot, models, num2name);

img_annotated = resized_img;
for i=1:height(all_face_pred)
img_annotated = insertObjectAnnotation(img_annotated,'rectangle', all_face_pred(i,1:4), num2name(all_face_pred(i,5)), 'LineWidth', 7, 'FontSize', 30);
end

imshow(img_annotated);