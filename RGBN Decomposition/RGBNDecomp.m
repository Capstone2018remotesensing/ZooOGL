close all; clear all; clc;

% if you only want Gray Scale, you can comment out the other lines for NIR and RGB 

% i guess you need Matlab 2018 to run the extractBefore() function... 
% if you dont have the 2018 version, u could just remove the newname line.

% i didnt know how to create a new folder for the new images. you can sort with file size. 


contents = dir('*.tif');

for k = 1:numel(contents)
    filename = contents(k).name;
    
    map = imread(filename);
    newmap1 = map(:,:,1:3);     %RGB
    newmap2 = rgb2gray(newmap1); %GRAY
    newmapIR= map(:,:,4);		%NIR
    
    [~,name,~] = fileparts(filename);
    newname = extractBefore(name,"_RGBN");
    gs = sprintf('%s_GRAY.tif', newname);
    nir = sprintf('%s_NIR.tif', newname);
    rgb = sprintf('%s_RGB.tif', newname);
    
    imwrite(newmap2, gs);
    imwrite(newmapIR, nir);
    imwrite(newmap1, rgb);
end