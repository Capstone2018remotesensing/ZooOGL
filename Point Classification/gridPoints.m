function [grid] = gridPoints(data,xmin,xmax,ymin,ymax)
% *************************************************************************
% Written by Kristy Guan
% This function sorts through the dataset to find points within the desire
% grid extents.
%
% Inputs:
%  - grnd: array containing dataset with x,y,z columns
%  - xmin: minimum x value
%  - xmax: maximmum x value
%  - ymin: minimum y value
%  - ymax: maximum y value
% Output:
%  - grid: array of points withint the minimum and maximum extents
% *************************************************************************

rows = size(data,1); % row size of dataset

index = false(rows,1); %logical (1 = in grid)

for i=1:rows
    if ( data(i,1)>=xmin ) && ( data(i,1)<=xmax )
        if ( data(i,2)>=ymin ) && ( data(i,2)<=ymax )
            index(i) = 1; %in grid
        end
    end
end

grid = data(index,:); % grid points

end

