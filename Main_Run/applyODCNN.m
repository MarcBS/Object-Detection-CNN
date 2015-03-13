function [ objects, maps ] = applyODCNN( img, ODCNN_params )
%APPLYODCNN Detects all the objects in the given image using the 
%   Object Detection CNN (ODCNN)
    
    %% Initialize caffe
    addpath(ODCNN_params.caffe_path);
    matcaffe_init(ODCNN_params.use_gpu, ODCNN_params.model_def_file, ODCNN_params.trained_net_file);
    
    %% Build Maps
    maps = buildObjectnessMaps(img, ODCNN_params);
    
    %% Extract objects list from maps
    [objects_list, scales] = mergeWindows(maps, ODCNN_params);
    objects.list = objects_list;
    objects.scales = scales;

end

