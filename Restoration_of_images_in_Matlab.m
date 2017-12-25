% File: Restoration_of_images_in_Matlab.m
% Description: Restoration of images in Matlab using inverse filtration technique
% Environment: Matlab
%
% MIT License
% Copyright (c) 2017 Valentyn N Sichkar
% github.com/sichkar-valentyn
%
% Reference to:
% [1] Valentyn N Sichkar. Restoration of images in Matlab using inverse filtration technique // GitHub platform [Electronic resource]. URL: https://github.com/sichkar-valentyn/Restoration_of_images_in_Matlab (date of access: XX.XX.XXXX)

close all;

%Reading an original image
original_image = imread('board.tif');

%Obtaining PSF for motion
Point_Spread_Function = fspecial('motion');

%Getting the blurred image
blurred_image = imfilter(original_image,Point_Spread_Function,'circular');

%Adding a noise to the blurred image
noise = 0.1*randn(size(original_image))/20.0;
blurred_image = im2double(blurred_image);
blurred_and_noisy = blurred_image+noise;

%Showing the resulted three images
figure(1);
subplot(1,3,1), imshow(original_image), title('Original image');
subplot(1,3,2), imshow(blurred_image), title('Blurred image');
subplot(1,3,3), imshow(blurred_and_noisy), title('Blurred and noisy image');

%Restoration of the blurred image
restoration_blurred = deconvwnr(blurred_image,Point_Spread_Function);
figure(2);
subplot(1,2,1), imshow(blurred_image), title('Blurred image');
subplot(1,2,2), imshow(restoration_blurred), title('Restoratied image');

%Restoration of image using ratio
nsr = sum(noise(:).^2)/sum(blurred_and_noisy(:).^2);
restoration_blurred_and_noisy = deconvwnr(blurred_and_noisy, Point_Spread_Function, nsr);
figure(3);
subplot(1,2,1), imshow(blurred_and_noisy), title('Blurred and Noisy image');
subplot(1,2,2), imshow(restoration_blurred_and_noisy), title('Restoratied image');

%Restoration of image using correlation function
np = abs(fftn(noise)).^2; %noise power
ncorr = fftshift(real(ifftn(np))); %noise autocorrelation function

ip = abs(fftn(blurred_and_noisy)); %original image power
icorr = fftshift(real(ifftn(ip))); %image autocorrelation function

restoration_blurred_and_noisy_2 = deconvwnr(blurred_and_noisy, Point_Spread_Function, ncorr, icorr);
figure(4);
subplot(1,2,1), imshow(blurred_and_noisy), title('Blurred and Noisy image');
subplot(1,2,2), imshow(restoration_blurred_and_noisy_2), title('Restoratied image');
