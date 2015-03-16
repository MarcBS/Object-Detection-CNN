
%% Parameters
loadParameters;

patches_per_scale = 3;

% im_name = '104_0437.JPG';
% im_name = '102_0260.JPG';
im_name = '108_0853.JPG';
% im_name = '109_0903.JPG';

img = imread([path_images '/' im_name]);
ratio_general = size(img,1)/size(img,2);
scale = [0 1];

load([path_maps '/' im_name '_maps.mat']); % maps
% load([path_maps '/' im_name '_objects.mat']); % objects

%% Generate objects list
[objects_list, scales] = mergeWindows(maps, ODCNN_params);
objects.list = objects_list;
objects.scales = scales;

%% Prepare plot dimensions
nCols = patches_per_scale;
nMaps = length(maps);
nRows = ceil(nMaps/nCols)+1;

%% Plot
f = figure;
% Fixed figure size
set(f, 'Position', [1 1 750 720])

%% Plot original image
ha = tight_subplot(nRows, nCols, [.02 .00],[.05 .01],[.01 .01]);
axes(ha(2)); imshow(img);

%% Remove unuseful figures
set(ha(1),'visible','off');
set(ha(3),'visible','off');

%% Plot each map
for i = 1:nMaps
    axes(ha(i+patches_per_scale)); h = imagesc(imresize(maps(i).map, [size(img,1) size(img,2)]), scale);
    % Copy original image aspect ratio
    aH = ancestor(h,'axes');
    axis equal;
    set(aH,'PlotBoxAspectRatio',[1 ratio_general 1])
    
    % Show x and y axis labels
	if(i > nMaps - patches_per_scale)
        xlabel(['patch props: [' num2str(maps(i).patch_props) ']']);
    end
    if(mod(i-1, patches_per_scale) == 0)
        ylabel(['image scale: [' num2str(maps(i).image_scale) ']']);
    end
end

%% Plot final object windows
f2 = figure;
set(f2, 'Position', [1200 650 100 200])
imshow(img);
title('Selected Bounding Boxes', 'FontSize', 14);

nScales = length(objects.scales);
for i = 1:nScales
    s = regexp(objects.scales{i}, '_', 'split');
    s = [str2num(s{1}) str2num(s{2})];
    objs = objects.list{i};
    
    ratio = size(img,2)/s(2);
    for o = objs'
        o = o*ratio;
        rectangle('Position', [o(1) o(2) o(3)-o(1)+1 o(4)-o(2)+1], 'EdgeColor', 'r', 'LineWidth', 2);
    end
end

%% Set colorbar
axes(ha(3));
colorbar('south');
caxis(scale);

