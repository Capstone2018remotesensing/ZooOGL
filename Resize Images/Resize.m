close all; clear all; clc;
% *************************************************************************
% Written by ZooOGL member Kristy Guan.
% Program was created using MATLAB 2018. Older version may be incompatible.
%
% A program created to reduce the size of large images. The program would
% resize all images within the same directory as the source code. The
% images are resized by a user-inputted percentage.

% Input:  Images in TIFF format (.tif). The format may be changed manually.
% Output: Images with reduced sizes.
% *************************************************************************

% get all tif files from directory
contents = dir('*.tif');

for k = 1:numel(contents)
    filename = contents(k).name;
    
    orig = imread(filename);
    resized = imresize(orig,0.7);   %70% of original size
    
    % Create new output name
    [~,name,~] = fileparts(filename);
    newname = sprintf('%s_70.tif', name);
    
    % Output new image
    imwrite(resized, newname);
end