
%% Parameters
ODCNN_params.caffe_path = '/usr/local/caffe-dev/matlab/caffe';
ODCNN_params.use_gpu = true;
ODCNN_params.model_def_file = '/usr/local/caffe-dev/models/objDetectCNN/train_val_finetunning_test.prototxt';
ODCNN_params.trained_net_file = '/media/lifelogging/HDD_2TB/Objects_Detection/trained_CNN/objDetectCNN_finetunning_v2_iter_16000.caffemodel';

ODCNN_params.batch_size = 50;
ODCNN_params.parallel = true; % use parallel computation or not

ODCNN_params.minObjVal = 0.7; % minimum objectness value threshold to consider a positive window as an object
ODCNN_params.mergeIoU = 0.001; % minimum intersection over union for merging two positively detected windows
ODCNN_params.mergeScales = true; % merge windows from different scales or not?

ODCNN_params.stride = 24; % pixel separation between each processed patch
ODCNN_params.input_patch = 256; % size of the input patch needed for the net
ODCNN_params.patch_size = [100 100]; % size of the crops on the image
ODCNN_params.patch_props = [[1 1]; [0.75 1]; [1 0.75]];
ODCNN_params.scales = [1 0.85 0.71 0.51 0.36];

%% Paths
path_maps = 'Maps';

path_images = '/media/lifelogging/Shared SSD/Object Discovery Data/Video Summarization Project Data Sets/MSRC/JPEGImages';
% path_images = '/Volumes/SHARED HD/Video Summarization Project Data Sets/MSRC/JPEGImages';


addpath('Utils;Evaluate_Results;Main_Run');