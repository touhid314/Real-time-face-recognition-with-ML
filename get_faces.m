function [faces, face_box, resized_img] = get_faces(img)
% this function returns a cell array containing all cropped image of the faces in the input
% image

I = img;
% resize image so that height*width  = 700kB
x = sqrt((700e3)/(height(I)*width(I)));
I = imresize(I, x);
resized_img = I;

faces = {};

faceDetector = vision.CascadeObjectDetector('FrontalFaceCART');
NoseDetector = vision.CascadeObjectDetector('Nose');
face_box = faceDetector(I);

% % preview of detected faces
% IFaces1 = insertObjectAnnotation(I,'rectangle',face_box, 'face');
% imshow(IFaces1);

% crop detected faces for every image
for i = 1:height(face_box)
    Icrop = imcrop(I, face_box(i,:));
    faces{length(faces)+1} = Icrop;
end
end