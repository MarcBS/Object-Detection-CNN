%% Runs the Object Discovery CNN on a set of test images
loadParameters;

%% For each images path
times = [];
count_paths = 1;
for path_images = list_paths_images
    
    disp(['## Processing path ' path_images{1}]);
    disp(' ');
    
    % Get list of images names
    path_images = path_images{1};
    list_imgs = dir([path_images '/*' list_formats{count_paths}]);
    list_imgs = list_imgs(arrayfun(@(x) ~strcmp(x.name(1),'.'), list_imgs));
    names = {list_imgs(:).name};
%     names = {'104_0437.JPG', '102_0260.JPG', '108_0853.JPG', '109_0903.JPG'};
    
    count = 1;
    nImages = length(names);
    this_times = zeros(nImages,1);
    for im_name = names
        disp(' ');
        disp(['## Processing image ' num2str(count) '/' num2str(nImages)]);
        disp(' ');
        img = imread([path_images '/' im_name{1}]);

        tic
    %     [ maps, objects ] = applyODCNN(img, ODCNN_params);
        [ maps ] = applyODCNN(img, ODCNN_params, false);
        time = toc;
        
        disp(['Elapsed time: ' num2str(time)]);
        this_times(count) = time;

        save([path_maps '/' num2str(count_paths) '_' im_name{1} '_maps.mat'], 'maps');
    %     save([path_maps '/' num2str(count_paths) '_' im_name{1} '_objects.mat'], 'objects');
        count = count+1;
    end
    times = [times; this_times];
    count_paths = count_paths+1;
end

save([path_maps '/times.mat'], 'times');
disp('Done');
exit;
