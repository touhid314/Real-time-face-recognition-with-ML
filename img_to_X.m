function [stacked_arr] = img_to_X(img)
%IMG_TO_X this function takes input an image.
% it resizes it to 32*32
% performs 2d wavelet transform
% stacks the original image and wavelet transformed image in a 1d array
% outputs the 1D array, which is the feature vector
% process the photo and add to X
img32 = imresize(img, [32, 32]);
img_1D = reshape(img32, 1, []);

%wavelet transformation
img_gray = double(rgb2gray(img));
n = 5;
dwtmode('per');
[C, S] = wavedec2(img_gray, n, 'db1');
[cHn, ~, ~] = detcoef2('all', C, S, n);

img_w2d = imresize(cHn, [32, 32]);
img_w2d = reshape(img_w2d, 1, []);
img_w2d = uint8(img_w2d);

stacked_arr = [img_1D, img_w2d];
end

