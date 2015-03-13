
loadParameters;

names = {'104_0437.JPG', '102_0260.JPG', '108_0853.JPG', '109_0903.JPG'};
count = 1;
nImages = length(names);
for im_name = names
    disp(' ');
    disp(['## Processing image ' num2str(count) '/' num2str(nImages)]);
    disp(' ');
    img = imread([path_images '/' im_name{1}]);

    tic
    [ objects, maps ] = applyODCNN(img, ODCNN_params);
    toc

    save([path_maps '/' im_name{1} '_maps.mat'], 'maps');
    save([path_maps '/' im_name{1} '_objects.mat'], 'objects');
    count = count+1;
end

disp('Done');
exit;
