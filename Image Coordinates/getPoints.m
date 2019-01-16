close all; clear; clc;

% Image distribution:
% Dawood: Flight Line #1, #3_2(1-9)
% Kristy: Flight Line #2,  #3_2(10-18)
% Lynn:	  Flight Line #3_1, #3_2(19-23), #7_1(1-4)
% Steve:  Flight Line #4, #7_1(5-13)
% Trisha: Flight Line #5, #7_1(14-15), #7_2(1-7)
% Tyler:  Flight Line #6, #7_2(7-15)

% 1) Change folder paths.

% 2) Program will ask for the number of points in the image in the Command
% Window below. Enter the number in the Command Window and press Enter.

% 3) On the image, zoom in to a point and click Space Bar to enable
% clicking on a point. Command Window will ask for point name. Return to
% image if there are more points to choose.

% Note: Keep checking Command Window to make sure to enter necessary
% information.

source='C:\Users\kyfguan\Downloads';
destination='C:\Users\kyfguan\Downloads\Marked Images'; %manually create folder first?
file='C:\Users\kyfguan\Downloads\Marked Images\points.txt';
extension='tif';

[files,points] = findPoints(source,destination,extension,file);

