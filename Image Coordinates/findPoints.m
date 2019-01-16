function [files,points] = findPoints( source,destination,extension,numberOfPoints,file)
%The function allows you to click points in all the images in a folder and
%save them to a file. The function arguments are:
%   source: The path to the folder of gray scale images.
%   extension: file extension e.g. 'tif'
%   numberOfPoints: the number of points you want to select in each image.
%   file: the path to the text file e.g. D:\points.txt
%   When you start the method, the first image will be shown, then you can
%   zoom the image until you find a suitable target, then press any key,
%   then you are allowed to click on the target and the pixel points will
%   be saved to a file. If you set the number of points to be 1, then you
%   will be allowed to click for a point at an image, then after you select
%   the point a new image appears.
%
path=strcat(source,'\*.',extension);
files=dir(path);
fid=fopen(file,'w');
n=3;
for i=1:n
    path=strcat(source,'\',files(i).name);
    img=imread(path);
    fprintf(fid,'%s\n',path);
    for j=1:numberOfPoints
        imshow(img);
        pause;
        pt=ginput(1);
        fprintf(fid,'%f\t%f\n',pt(1),pt(2));
        points(i,j,1:2)=[pt(1),pt(2)];
    end
end
for i=1:n
    path=strcat(source,'\',files(i).name);
    img=imread(path);
    path2=strcat(destination,'\',files(i).name);
    figure
    imshow(img);
    hold on;
    for j=1:numberOfPoints
        plot(points(i,j,1),points(i,j,2),'Marker','o','MarkerFaceColor','red','MarkerSize',10);
    end
    print(path2,'-dtiff');
    close all;
end
fclose(fid);
end

