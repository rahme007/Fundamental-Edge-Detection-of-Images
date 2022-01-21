close all;
im1 = imread('window_synt.jpg');
im1 = rgb2gray(im1);
edge_op1 = [-1 2 -1; -1 2 -1;-1 2 -1]; % Vetical line
edge_op2 = [-1 -1 -1; 2 2 2; -1 -1 -1];% Horizontal Line
edge_op3 = [1 -2 1; 1 -2 1; 1 -2 1]; % Vertical Gap
edge_op4 = [1 1 1; -2 -2 -2; 1 1 1]; % Horizontal gap
edge_op5 = [1 0 -1; 1 0 -1; 1 0 -1]; % falling Vertical
edge_op6 = [1 1 1; 0 0 0; -1 -1 -1]; % falling horizontal
edge_op7 = [-1 0 1; -1 0 1;-1 0 1]; %rising vertical
edge_op8 = [-1 -1 -1;0 0 0; 1 1 1]; %rising horizontal
combined = zeros(size(im1));
% Created Edge Operator Implementation
for angle = 0:10:20
    ime1 = operation(im1,angle,edge_op1);
    combined = combined + ime1;
    ime2 = operation(im1,angle,edge_op2);
    combined = combined + ime2;
    ime3 = operation(im1,angle,edge_op3);
    combined = combined + ime3;
    ime4 = operation(im1,angle,edge_op4);
    combined = combined + ime4;
    ime5 = operation(im1,angle,edge_op5);
    combined = combined + ime5;
    ime6 = operation(im1,angle,edge_op6);
    combined = combined + ime6;
    ime7 = operation(im1,angle,edge_op7);
    combined = combined + ime7;
    ime8 = operation(im1,angle,edge_op8);
    combined = combined + ime8;
   figure,imshow(combined)
end
%% Kirsch Operator
imkirsch = kirschedge(im1); % function given by Sarojkumar for Kirschedge
imk = zeros(size(imkirsch));
threshold_k = mean(imkirsch(:)); 
indices = abs(imkirsch)>threshold_k;
imk(indices) = 255;
figure,imshow(imcomplement(imk));

%% Prewitt Compass
imprewitt = edge(im1,'Prewitt');
figure,imshow(imcomplement(imprewitt)) 

%% Higher Degrees of Fuzziness
fuzz_1 = [-3 -3 -3 -3 -3; 2 2 2 2 2; 2 2 2 2 2; 2 2 2 2 2;
    -3 -3 -3 -3 -3]; % Horizontal Line
fuzz_2 = fuzz_1'; % Vertical Line
fuzz_3 = [-1 -1 -1 -1 -1; -1 -1 -1 -1 -1; 
    0 0 0 0 0;1 1 1 1 1; 1 1 1 1 1]; %Horiontal Rising_edge
fuzz_4 = fuzz_3'; %Vertical Rising Edge

% Combined fuzziness
combined_fuzz = zeros(size(im1));
combined_fuzz = combined_fuzz + operation(im1,0,fuzz_1);
combined_fuzz = combined_fuzz + operation(im1,0,fuzz_2);
combined_fuzz = combined_fuzz + operation(im1,0,fuzz_3);
combined_fuzz = combined_fuzz + operation(im1,0,fuzz_4);
figure,imshow(combined_fuzz)

% working with blurred image
im_blur = imgaussfilt(im1,5);
combined_fblur = zeros(size(im1));
imb1 = operation(im_blur,0,fuzz_1);
combined_fblur = combined_fblur + imb1; 
imb2 = operation(im_blur,0,fuzz_2);
combined_fblur = combined_fblur + imb2;
% imb3 = operation(im_blur,0,fuzz_3);
% combined_fblur = combined_fblur + imb3;
% imb4 = operation(im_blur,0,fuzz_4);
% combined_fblur = combined_fblur + imb4;

figure,imshow(combined_fblur)


function t = operation(im,angle,edge_op)
        im = imrotate(im,angle,'crop');
        im = imfilter(im,edge_op);
        threshold = mean(im(:)); 
        indices = abs(im)>threshold;
        im(indices) = 255;
        im = imrotate(im,-angle,'crop');
        t = double(im);
end