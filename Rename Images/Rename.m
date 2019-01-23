close all; clear all; clc;

contents = dir('*.tif');

for k = 1:numel(contents)
    filename = contents(k).name;
    orig = imread(filename);
    
    %extract flight & img no., eg. _001_023
    flight = extractAfter(filename,"5cm");
    flight = extractBefore(flight,"_id");
    
    %extract time, eg. 20181012xxxxxx
    time = extractBefore(filename,"_GRAY");
    time = extractAfter(time,"82517_");
    
    %combine name, eg. 20181012xxxxxx_001_023_GRAY.tif
    newname = [time flight];
    newname = sprintf('%s_GRAY.tif',newname);
    
    %rename file
    movefile(filename,newname);
end