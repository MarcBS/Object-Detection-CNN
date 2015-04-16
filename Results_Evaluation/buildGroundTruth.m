function [ objects ] = buildGroundTruth( objects, threshold_detection )
%BUILDGROUNDTRUTH Analyzes the GT and applies a matching on each of the 
% object candidate windows.

    nSamples = length(objects);

    for j = 1:nSamples
        nGT = length(objects(j).ground_truth);
        
        %% Initialize object candidates
        nObjs = length(objects(j).objects);
        for k = 1:nObjs
            objects(j).objects(k).OS = zeros(1, nGT);
            objects(j).objects(k).trueLabel = 'No Object';
            objects(j).objects(k).trueLabelId = [];
        end

        %% For each object
        for k = 1:nGT
            %% Check if any object in objects(j).objects matches 
            %  with the ground_truth for assign them the true label!
            GT = objects(j).ground_truth(k);
            GT.height = (GT.BRy - GT.ULy + 1);
            GT.width = (GT.BRx - GT.ULx + 1);
            GT.area = GT.height * GT.width;

            %% Check for each object candidate, if it fits the current true object
            count_candidate = 1;
            for w = objects(j).objects
                if(~isempty(w.ULx)) % if the list of candidates is not empty
                    % Check area and intersection on current window "w"
                    w.height = (w.BRy - w.ULy + 1);
                    w.width = (w.BRx - w.ULx + 1);
                    w.area = w.height * w.width;

                    % Check intersection
                    count_intersect = rectint([GT.ULy, GT.ULx, GT.height, GT.width], [w.ULy, w.ULx, w.height, w.width]);
                        
                    % Calculate overlap score
                    OS = count_intersect / (GT.area + w.area - count_intersect);

                    if(OS > threshold_detection) % object detected!
                        label = objects(j).ground_truth(k).name;
                        % If OS bigger than previous, then assign this
                        if(max(w.OS) < OS)
                            w.trueLabel = label;
                            w.trueLabelId = k;
                        end
                    end
                    w.OS(k) = OS;

                    % Store w object
                    objects(j).objects(count_candidate).OS = w.OS;
                    objects(j).objects(count_candidate).trueLabel = w.trueLabel;
                    objects(j).objects(count_candidate).trueLabelId = w.trueLabelId;

                    count_candidate = count_candidate + 1;
                end
            end
        end
    end 

end

