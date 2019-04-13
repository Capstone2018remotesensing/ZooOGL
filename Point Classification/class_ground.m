close all;
% clear all; clc;
% *************************************************************************
% Written by Kristy Guan with the help of Hani Mohammed. This program was
% developed in MATLAB 2018 and may not be compatible with older versions.
%
% Classifies ground points using a mode height filter, a red filter, and
% height comparison using KD Tree and range searcher.
% 
% Note 1: User may need to manual change file names and/or file directories. 
% Note 2: Run KD Tree and/or rangesearcher ONCE and save the outputs in .mat
%         files and load when needed. 
% 
% Input:
%  - Reads in point cloud as .txt file. Format should be x,y,z, r,g,b, ?,?,
%    and intensities.
% Output:
%  - text file containing all points classified as ground
%  - text file containing remaining points not classified as ground
%
% Warning: Do NOT use KDTree and rangesearcher section if dataset spacing 
%          is dense and search radius is large.
% *************************************************************************

filename = 'all_lidar_merged_50cm_zoo.txt';
name = extractBefore(filename,".txt");
save_name = name;

%% Load data
data = load(filename);
data = [data(:,1:4), data(:,12)]; %save xyz,red,intensity
save([name '_data.mat'],'data'); % save data

l = size(data,1); % length of dataset
index_data = true(l,1);
data(:,6) = 1:l; % indices for reference, delete column later


%% Grid Data
xmin = min(data(:,1)); xmax = max(data(:,1));
ymin = min(data(:,2)); ymax = max(data(:,2));

space=300;

xgrid = [xmin:space:xmax,xmax]';
ygrid = [ymin:space:ymax,ymax]';

xsize = length(xgrid);
ysize = length(ygrid);

clear xmin xmax ymin ymax space;


%% Filter (height and reds)

tic % timer on

for i=1:xsize-1
    for j=1:ysize-1
        fprintf('i=%d, j=%d --------------------------------------\n',i,j);
        
        % get all points within grid
        grid = gridPoints(data,xgrid(i,1),xgrid(i+1,1),ygrid(j,1),ygrid(j+1,1));
        
        % height mode (most common height)
        h_avg=mode(grid(:,3));
        
        for k=1:size(grid,1)
            % filter out points above height threshold
            if (grid(k,3)>h_avg+5)
                index_data(grid(k,6))=0;
            end
            % filter out points below height threshold
            if (grid(k,3)<h_avg-40) % scattered points (outliers)
                index_data(grid(k,6))=0;
            end
            % remove red points
            if (grid(k,4)>220)
                index_data(grid(k,6))=0;
            end
        end
    end
end

toc % timer off

% get filtered points
filtered=data(index_data,:); % filtered ground
building=data(logical(abs(index_data-1)),:);

% plot ground and non-ground points
figure; hold on;
scatter3(filtered(:,1),filtered(:,2),filtered(:,3),'.');
scatter3(building(:,1),building(:,2),building(:,3),'.r');
hold off;

save([save_name '_xground.mat'],'filtered'); % save ground
save([save_name '_xothers.mat'],'building'); % save others


%% KD Tree search
% Beware! Time consuming! Especially with large datasets!

tic % timer on

idx_g=cell(l,1);

Tree=KDTreeSearcher(filtered(:,1:2));
save([save_name '_Tree.mat'],'Tree'); % save Tree

% 2D range search
for i=1:l
    idx_g{i}=rangesearch(Tree,filtered(i,1:2),5); % 5m search range
    if ~mod(i,1000)
        fprintf('mod i=%d\n',i);
    end
end
save([save_name '_idx_g.mat'],'idx_g'); % save idx


%% Height Comparison
for i=1:l
    m=mode(filtered(idx_g{i}{1},3));
    for j=1:length(idx_g{i}{1})
        if filtered(idx_g{i}{1}(j),3)-m>1.5 % 1-2 meters?
            index_data(filtered(idx_g{i}{1}(j),6))=0;
        end
    end
    if ~mod(i,1000)
        fprintf('mod i=%d\n',i);
    end
end
save([save_name '_index_data.mat'],'index_data'); % save index_data (just added...)

toc % timer off

ground_all=data(index_data,1:5);
others_all=data(logical(abs(index_data-1)),1:5);

figure; hold on;
scatter3(ground_all(:,1),ground_all(:,2),ground_all(:,3),'.');
scatter3(others_all(:,1),others_all(:,2),others_all(:,3),'.r');
hold off;


%% Save ground and non-ground
dlmwrite('output_ground.txt',ground_all,'precision',8);
dlmwrite('output_others.txt',others_all,'precision',8);

