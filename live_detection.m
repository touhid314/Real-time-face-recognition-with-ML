close all;
clear all;

c=webcam;

faceDetector=vision.CascadeObjectDetector('FrontalFaceLBP');
mdl_file = load('models.mat');
models = mdl_file.models;
model = models{1,1}; %using svm model
num2name = mdl_file.num2name;
rot = 0; %rotaion needed in degrees in counterclockwise direction


while true
    e=c.snapshot;

    bboxes = faceDetector(e);
    if(height(bboxes)~=0)
        [all_face_pred, resized_img, num2name] = predict_img(e, rot, models, num2name);

        if height(all_face_pred) ~= 0
            img_annotated = resized_img;
            for i=1:height(all_face_pred)
                img_annotated = insertObjectAnnotation(img_annotated,'rectangle', all_face_pred(i,1:4), num2name(all_face_pred(i,5)), 'LineWidth', 7, 'FontSize', 30);
            end
            image(img_annotated);
            drawnow;

        else
            image(e);
            drawnow;
        end
    else
        image(e);
        drawnow;
    end
end