function [files,points] = findPoints(source,destination,extension,file)
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

path=strcat(source,'\*.',extension);
files=dir(path);
fid=fopen(file,'w');
for i=1:length(files)
    path=strcat(source,'\',files(i).name);
    img=imread(path);
    
    fprintf('%s\n',path);
    prompt='Number of points in this image? ';
    numberOfPoints=input(prompt);
    
    for j=1:numberOfPoints
        imshow(img);
        pause;
        pt=ginput(1);
        
        prompt2='Point name? ';
        pt_name=input(prompt2);
        
        fprintf(fid,'%s\t%i\t%f\t%f\t\n',path,pt_name,pt(1),pt(2));
        points(i,j,1:2)=[pt(1),pt(2)];
    end
    
    path2=strcat(destination,'\',files(i).name);
    figure
    imshow(img);
    hold on;
    for j=1:numberOfPoints
        plot(points(i,j,1),points(i,j,2),'Marker','x','MarkerFaceColor','red','MarkerSize',20);
    end
    print(path2,'-dtiff');
    close all;
end
fclose(fid);
end