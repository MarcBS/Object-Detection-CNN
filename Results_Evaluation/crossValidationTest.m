
%% This script runs a cross validation on the splitted validation data for 
%   selecting the best parameter combination for each margin method.

%% Specific Cross-Validation parameters
mergeType_values = {'IoU', 'NMS', 'MS'};
minObjVal_values = {0.6, 0.7, 0.8, 0.9};
mergeScales_values = {true, false};
% Thresholds used for each of the methods (in the same order as
% mergeType_values)
mergeThreshold_values = {{0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2}, ...
                        {0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2}, ...
                        {0.3, 0.4, 0.45, 0.5, 0.55}};

%% Load general Parameters
cd ..
loadParameters;

%% Load validation data split
load(train_val_split); % images_list
val_split = images_list{2};


%% For each image
nImages = size(val_split,1);
count_imgs = 1;
prev_folder = '';
objectsCV = struct('imgName', [], 'folder', []);
for img_ind = val_split'

    disp(' ');
    disp(['## Processing image ' num2str(count_imgs) '/' num2str(nImages)]);
    disp(' ');
    
    % Reload objects structure if we have changed the current folder
    if(~strcmp(prev_folder, list_paths_images{img_ind(1)}))
        prev_folder = list_paths_images{img_ind(1)};
        load([path_objects '/' objects_folders{img_ind(1)} '/objects.mat']);
    end
    tic
    
    % Store ground truth information
    objectsCV.ground_truth = objects(img_ind(2)).ground_truth;
    objectsCV.imgName = objects(img_ind(2)).imgName;
    objectsCV.folder = objects(img_ind(2)).folder;
    
    % Prepare tests parameters and resulting object candidates
    objectsCV.test = struct('mergeType', [], 'minObjVal', [], 'mergeScales', [], 'mergeThreshold', [], 'objects', []);
    
    % Load maps results
    load([path_maps '/' num2str(img_ind(1)) '_' objects(img_ind(2)).imgName '_maps.mat']); % maps
    
    %% For each mergeType
    count_type = 1;
    count_tests = 1;
    for mergeType = mergeType_values
        ODCNN_params.mergeType = mergeType{1};
        %% For each minObjVal
        for minObjVal = minObjVal_values
            ODCNN_params.minObjVal = minObjVal{1};
            %% Whether we merge all scales or not
            for mergeScales = mergeScales_values
                ODCNN_params.mergeScales = mergeScales{1};
                
                %% Apply tests for all the chosen thresholds
                [objects_list, scales] = mergeWindowsCV(maps, ODCNN_params, mergeThreshold_values{count_type});
                this_all_objects.list = objects_list;
                this_objects.scales = scales;
                
                % Get max scale
                maxScale = -1;
                maxScale_val = [-Inf -Inf];
                countScales = 1;
                for s = scales
                    s = regexp(s{1}, '_', 'split');
                    s = [str2num(s{1}) str2num(s{2})];
                    if(s(1) > maxScale_val(1))
                        maxScale_val = s;
                        maxScale = countScales;
                    end
                    countScales = countScales+1;
                end
                
                count_threshold = 1;
                for mergeThreshold = mergeThreshold_values{count_type}
                    ODCNN_params.mergeThreshold = mergeThreshold{1};
                    
                    % Store information for this parameter combination
                    objectsCV.test(count_tests).mergeType = ODCNN_params.mergeType;
                    objectsCV.test(count_tests).minObjVal = ODCNN_params.minObjVal;
                    objectsCV.test(count_tests).mergeScales = ODCNN_params.mergeScales;
                    objectsCV.test(count_tests).mergeThreshold = ODCNN_params.mergeThreshold;
                    
                    % Apply parameters and extract objects
                    this_objects.list = this_all_objects.list{count_threshold};
                    
                    % Store resulting objects
                    count_objects = 1;
                    nScales = length(this_objects.list);
                    for i = 1:nScales
                        s = regexp(this_objects.scales{i}, '_', 'split');
                        s = [str2num(s{1}) str2num(s{2})];
                        objs = this_objects.list{i};

                        ratio = maxScale_val(2)/s(2);
                        for o = objs'
                            o = o*ratio;
                            objectsCV.test(count_tests).objects(count_objects).ULx = o(1);
                            objectsCV.test(count_tests).objects(count_objects).ULy = o(2);
                            objectsCV.test(count_tests).objects(count_objects).BRx = o(3);
                            objectsCV.test(count_tests).objects(count_objects).BRy = o(4);
                            count_objects = count_objects+1;
                        end
                    end
                    
                    count_tests = count_tests+1;
                    count_threshold = count_threshold+1;
                end

            end
        end
        count_type = count_type+1;
    end
    
    time = toc;
    disp(['Elapsed time: ' num2str(time)]);
    
    % Save temporal results
    if(mod(count_imgs, 100) == 0)
        save(['tmp_cv_results/tmp_state_' num2str(count_imgs) '.mat']);
    end
    
    count_imgs = count_imgs+1;
end

%% Save Results
save('CrossValidation_validation_set.mat', 'objectsCV');

disp('Done');
exit;