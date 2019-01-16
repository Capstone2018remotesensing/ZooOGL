close all; clear all; clc;

contents = dir('*.tif');

for k = 1:numel(contents)
    filename = contents(k).name;
    
    orig = imread(filename);
    resized = imresize(orig,0.7);   %70% of original size
        
    [~,name,~] = fileparts(filename);
    newname = sprintf('%s_70.tif', name);
    
    imwrite(resized, newname);
end