close all;
% clear all; clc;
% *************************************************************************
% Written by Kristy Guan with the guidance of Hani Mohammed. The program
% was developed in MATLAB 2018 and may not be compatible with older
% versions.
%
% Classifies non-ground points into linear, planar, scattered, outliers,
% and unclassified using KD Tree and range searcher, covariance and
% eigenvalues.
% 
% Note 1: User may need to manual change file names and/or file directories. 
% Note 2: Run KD Tree and/or rangesearcher ONCE and save the outputs in .mat
%         files and load when needed. 
%
% Input:
%  - Reads in non-ground .txt file from class_ground program. Format should
%    be x,y,z, r, intensities
% Output:
%  - five text files:
%       1. linear class
%       2. planar class
%       3. scattered class
%       4. outlier class
%       5. unclassified
%       6. all points, with classes numbers in column 6
% *************************************************************************

filename = 'output_others_50cm_zoo.txt';
name = extractBefore(filename,".txt");
save_name = name;

%% Load data
data = load(filename);
save([name '_data.mat'],'data');

l=size(data,1);
h_avg=mode(data(:,3));


%% KD Tree search
% Beware! Time consuming!

tic % timer on

idx=cell(l,1);

Tree=KDTreeSearcher(data(:,1:3));
save([save_name '_Tree.mat'],'Tree'); % save Tree

% 3D range search
for i=1:l
    idx{i}=rangesearch(Tree,data(i,1:3),2); %3m search range
    if ~mod(i,1000)
        fprintf('i=%d\n',i);
    end
end
save([save_name '_idx.mat'],'idx'); % save idx
toc % timer off


%% Classifying Linear, Planar, and Scattered Point Features
idx_p=false(l,5);

tic % timer on
for i=1:l
    c=cov(data(idx{i}{1},1:3)); % covariance
    e=eig(c); % eigen
    
    diff = 0.4; % trial and error?
    same = 0.4;
    
    if size(e,1)==3
        % compare eigenvalues ------------------------------------ edit pls
        if (abs(e(3)-e(2)) >= diff) && (abs(e(2)-e(1)) < same)
            %e3>>e2 && e2>=e1: linear
            idx_p(idx{i}{1}(1),1)=1;
            data(idx{i}{1}(1),6)=1;
        elseif (abs(e(3)-e(2)) < same) && (abs(e(2)-e(1)) >= diff)
            %e3>=e2 && e2>>e1: planar
            idx_p(idx{i}{1}(1),2)=1;
            data(idx{i}{1}(1),6)=2;
        elseif (abs(e(3)-e(2)) < same) && (abs(e(2)-e(1)) < same)
            %e3>=e2>=e1: scatter
            idx_p(idx{i}{1}(1),3)=1;
            data(idx{i}{1}(1),6)=3;
        else % not classified
            idx_p(idx{i}{1}(1),5)=1;
            data(idx{i}{1}(1),6)=5;
        end
    else % outlier, no points within search range
        idx_p(idx{i}{1}(1),4)=1;
        data(idx{i}{1}(1),6)=4;
    end
end
toc % timer off

linear = data(idx_p(:,1),1:5);
planar = data(idx_p(:,2),1:5);
scatter = data(idx_p(:,3),1:5);
outlier = data(idx_p(:,4),1:5);
none = data(idx_p(:,5),1:5);

figure; hold on;
scatter3(linear(:,1),linear(:,2),linear(:,3),'.');
scatter3(planar(:,1),planar(:,2),planar(:,3),'.');
scatter3(scatter(:,1),scatter(:,2),scatter(:,3),'.');
scatter3(none(:,1),none(:,2),none(:,3),'.');
scatter3(outlier(:,1),outlier(:,2),outlier(:,3),'.');
legend('linear','planar','scatter','outlier','none');
xlabel('x'); ylabel('y'); zlabel('z');
hold off;


%% Save
dlmwrite('output_others3_linear.txt',linear,'precision',8);
dlmwrite('output_others3_planar.txt',planar,'precision',8);
dlmwrite('output_others3_scatter.txt',scatter,'precision',8);
dlmwrite('output_others3_outlier.txt',outlier,'precision',8);
dlmwrite('output_others3_none.txt',none,'precision',8);
dlmwrite('output_others2_all.txt',data,'precision',8);

