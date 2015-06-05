function [ all_TPs, all_FPs, TP, FP ] = getTPs( objects )
%GETTPS Summary of this function goes here
%   Detailed explanation goes here

    FP = 0;
    TP = 0;

    nImgs = length(objects);
    
    % Count TP & FP
    for i = 1:nImgs
        nObjs = length(objects(i).objects);
        for j = 1:nObjs
            if(~strcmp('No Object', objects(i).objects(j).trueLabel))
                TP = TP+1;
            else
                FP = FP+1;
            end
        end
    end
    
    % Store TP & FP
    count_TP = 0;
    count_FP = 0;
    all_TPs = zeros(TP, 4); % [img_id, obj_id, label_id, confidence] for each TP sample
    all_FPs = zeros(TP, 4); % [img_id, obj_id, -1, confidence] for each FP sample
    for i = 1:nImgs
        nObjs = length(objects(i).objects);
        for j = 1:nObjs
            if(~strcmp('No Object', objects(i).objects(j).trueLabel))
                all_TPs(count_TP+1,:) = [i j objects(i).objects(j).trueLabelId objects(i).objects(j).confidence];
                count_TP = count_TP+1;
            else
                all_FPs(count_FP+1,:) = [i j -1 objects(i).objects(j).confidence];
                count_FP = count_FP+1;
            end
        end
    end
    
end

