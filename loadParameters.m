
%% Parameters
ODCNN_params.caffe_path = '/usr/local/caffe-dev/matlab/caffe';
ODCNN_params.use_gpu = true;
ODCNN_params.model_def_file = '/media/lifelogging/HDD_2TB/Object-Detection-CNN/trained_CNN/train_val_finetunning_test.prototxt';
ODCNN_params.trained_net_file = '/media/lifelogging/HDD_2TB/Object-Detection-CNN/trained_CNN/objDetectCNN_finetunning_v2_iter_18000.caffemodel';

ODCNN_params.batch_size = 50;
ODCNN_params.parallel = true; % use parallel computation or not

% 'IoU': intersection over union, 'NMS': non-maximal suppression, 'MS': match score
ODCNN_params.mergeType = 'MS';
ODCNN_params.minObjVal = 0.8; % minimum objectness value threshold to consider a positive window as an object
ODCNN_params.mergeScales = true; % merge windows from different scales or not?
ODCNN_params.mergeThreshold = 0.1; % threshold used for any of the merging methods


ODCNN_params.stride = 24; % pixel separation between each processed patch
ODCNN_params.input_patch = 256; % size of the input patch needed for the net
ODCNN_params.patch_size = [100 100]; % size of the crops on the image
ODCNN_params.patch_props = [[1 1]; [0.75 1]; [0.5 1]; [1 0.75]; [1 0.5]];
ODCNN_params.scales = [1 0.85 0.71 0.51 0.36 0.21];

%% Paths
path_maps = 'Maps';

% path_images = '/media/lifelogging/Shared SSD/Object Discovery Data/Video Summarization Project Data Sets/MSRC/JPEGImages';
path_images = '/Volumes/SHARED HD/Video Summarization Project Data Sets/MSRC/JPEGImages';

format = '.JPG';

%% Parameters for runODCNN
train_val_split = 'Data_Preparation/train_val_split.mat';

path_objects = '/Volumes/SHARED HD/Video Summarization Objects/Features';
% path_objects = '/media/lifelogging/HDD_2TB/Video Summarization Objects/Features';

% list_paths_images = {'/Volumes/SHARED HD/Video Summarization Project Data Sets/MSRC/JPEGImages', ...
%     '/Volumes/SHARED HD/Video Summarization Project Data Sets/PASCAL_12/VOCdevkit/VOC2012/JPEGImages'};
list_paths_images = {'/media/lifelogging/Shared SSD/Object Discovery Data/Video Summarization Project Data Sets/MSRC/JPEGImages', ...
    '/media/lifelogging/Shared SSD/Object Discovery Data/Video Summarization Project Data Sets/PASCAL_12/VOCdevkit/VOC2012/JPEGImages'};

% PASCAL 1, MSRC 1.25
prop_res = {1.25, 1};

objects_folders = {'Data MSRC Ferrari', 'Data PASCAL_12 Ferrari'};


    
addpath('Utils;Windows_Merging;Windows_Merging/NMS;Main_Run;Results_Evaluation');
