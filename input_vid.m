clear all; close all;

tic;
%variables for predict_img input
mdl_file = load('models.mat');
models = mdl_file.models;
num2name = mdl_file.num2name;
% faceDetector = vision.CascadeObjectDetector('FrontalFaceLBP');
% EyeDetector = vision.CascadeObjectDetector('EyePairSmall');
% NoseDetector = vision.CascadeObjectDetector('Nose');

% take video for predicting
[file, path] = uigetfile({'*.*'});

if isequal(file, 0)
    disp('cancelled');
    return;
else
    try
        vidObj = VideoReader(string(path) + string(file));
        videoFReader = vision.VideoFileReader(string(path) + string(file));
    catch
        disp('invalid file format');
        return;
    end
end

% video file to write
video= VideoWriter("PREDICTED_"+string(file));
video.FrameRate = vidObj.FrameRate; clear vidObj;
open(video);

rot = 0;

frame = 1;
while ~isDone(videoFReader)
    frame
    % setting current time so that 10 frames are read per second
    
%     vidObj.CurrentTime = vidObj.CurrentTime + n*del_t;
    vidFrame = videoFReader();
    vidFrame = uint8(vidFrame*255);
    [all_face_pred, resized_img, num2name] = predict_img(vidFrame, rot, models, num2name);

    img_annotated = resized_img;
    for i=1:height(all_face_pred)
        img_annotated = insertObjectAnnotation(img_annotated,'rectangle', all_face_pred(i,1:4), num2name(all_face_pred(i,5)), 'LineWidth', 7, 'FontSize', 30);
    end
    
    writeVideo(video,mat2gray(img_annotated));

    frame = frame + 1;

    % DELETE THIS LINE IN PRODUCTION
    if frame > 200, break; end;
end

close(video);
toc;