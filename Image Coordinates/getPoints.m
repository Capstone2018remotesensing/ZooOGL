close all; clear; clc;
% *************************************************************************
% Developed using MATLAB 2018. Older version may not be compatible.
%
% Instructions:
% 1) Change folder paths.
% 2) Program will ask for the number of points in the image in the Command
%    Window below. Enter the number in the Command Window and press Enter.
% 3) On the image, zoom in to a point and click Space Bar to enable
%    clicking on a point. Command Window will ask for point name. Return to
%    image if there are more points to choose.
% Note: Keep checking Command Window to make sure to enter necessary
%       information.
% *************************************************************************

source='C:\Users\kyfguan\Downloads'; % manually change source path to images
destination='C:\Users\kyfguan\Downloads\Marked Images'; % manually create folder first
file='C:\Users\kyfguan\Downloads\Marked Images\points.txt'; % output file containing coordinates
extension='tif'; % file type extension

[files,points] = findPoints(source,destination,extension,file);

