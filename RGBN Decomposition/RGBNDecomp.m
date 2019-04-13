close all; clear all; clc;
% *************************************************************************
% Written by ZooOGL member Kristy Guan and Tyler Greene, with guidance from
% Hani Mohammed.
% Program was created using MATLAB 2018. Older version may be incompatible.
%
% A program created to decompose RBGN images into grayscale, RGB-only,
% and/or NIR-only images.
%
% Input:  Images in TIFF format (.tif). Images intended for decomposition
%         must be in the same folder as source code.
% Output: Grayscale, RGB-only, and/or NIR-only images, outputted into the
%         same directory as source code.
%
% Note: If only grayscale images are wanted, please comment out lines for
%       NIR and RGB generation.
% *************************************************************************

% get all tif files from directory
contents = dir('*.tif');

for k = 1:numel(contents)
    filename = contents(k).name;
    
    % Decomposition
    map = imread(filename);
    newmap1 = map(:,:,1:3);      % RGB
    newmap2 = rgb2gray(newmap1); % GRAY
    newmapIR= map(:,:,4);	     % NIR
    
    % Create new file name
    [~,name,~] = fileparts(filename);
    newname = extractBefore(name,"_RGBN");
    gs = sprintf('%s_GRAY.tif', newname);
    nir = sprintf('%s_NIR.tif', newname);
    rgb = sprintf('%s_RGB.tif', newname);
    
    % Output new image
    imwrite(newmap2, gs);
    imwrite(newmapIR, nir);
    imwrite(newmap1, rgb);
end