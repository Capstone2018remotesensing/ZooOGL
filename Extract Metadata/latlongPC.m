close all; clear all; clc;
contents = dir('*.tif');

% Open a text file
fid = fopen('latlong7_2.txt','w');

% Loop over the images
for k = 1:numel(contents)
    % Get image name
    filename = contents(k).name;
    % Write image name to text file
    fprintf(fid,'%s\t%d\t',filename,k);
    % Extract metadata
    meta = imfinfo(filename);
    % Compute XYZ of PC
    temp = reshape(meta.ModelTransformationTag,[4,4])';
    ans = temp*[5168 3894 0 1]';
    % Write lat&long into text file
    fprintf(fid,'%f\t%f\n',ans(1,1),ans(2,1));
end
% close text file
fclose(fid);
