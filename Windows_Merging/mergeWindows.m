function [ obj_windows, scales ] = mergeWindows( maps, ODCNN_params )
%MERGEWINDOWS It merges the detected object windows from each different
%   scale if their IoU is big enough.

    obj_windows = {};
    min_confidence = ODCNN_params.minObjVal;
    merge_scales = ODCNN_params.mergeScales;

    %% Sort maps by image scales
    bigger_scale_val = 0; bigger_scale_ind = 0;
    scales = {};
    indScales = {};
    nMaps = length(maps);
    for i = 1:nMaps
        s = maps(i).image_scale;
        pos_scale = find(ismember(scales, [num2str(s(1)) '_' num2str(s(2))]));
        if(isempty(pos_scale))
            scales = {scales{:}, [num2str(s(1)) '_' num2str(s(2))]};
            pos_scale = length(scales);
        end
        if(sum(s) > bigger_scale_val)
            bigger_scale_ind = pos_scale;
            bigger_scale_val = sum(s);
        end
        try
            indScales{pos_scale} = [indScales{pos_scale}(:); i];
        catch
            indScales{pos_scale} = [i];
        end
    end
    
    if(~merge_scales)
        %% For each different scale
        nScales = length(scales);
        for i = 1:nScales
            this_ind = indScales{i};
            W = [];
            for ind = this_ind'
                if(maps(ind).nWindows > 0)
                    this_windows = maps(ind).windows(maps(ind).confidence >= min_confidence,:);
                    W = [W; this_windows];
                end
            end

            if(strcmp(ODCNN_params.mergeType, 'IoU'))
                % Keep merging while there are enough similar windows
                nW = Inf;
                d = [];
                while(nW > size(W,1))
                    nW = size(W,1);
                    [W, d] = mergeBestIOU(W, ODCNN_params.mergeThreshold, d);
                end
            elseif(strcmp(ODCNN_params.mergeType, 'NMS'))
                W = nms(W, ODCNN_params.mergeThreshold);
            elseif(strcmp(ODCNN_params.mergeType, 'MS'))
                this_scale = regexp(scales{i}, '_', 'split');
                this_scale = [str2num(this_scale{1}) str2num(this_scale{2})];
                W = matchScoring(W, ODCNN_params.mergeThreshold, this_scale);
            end
            obj_windows{i} = W;
        end
        
    else
        %% Get all windows resized to the bigger scale
        nScales = length(scales);
        W = [];
        bigger_scale = scales{bigger_scale_ind};
        bigger_scale = regexp(bigger_scale, '_', 'split');
        bigger_scale = [str2num(bigger_scale{1}) str2num(bigger_scale{2})];
        for i = 1:nScales
            this_scale = scales{i};
            this_ind = indScales{i};
            
            this_scale = regexp(this_scale, '_', 'split');
            this_scale = [str2num(this_scale{1}) str2num(this_scale{2})];
            ratio = bigger_scale(2)/this_scale(2);
            
            for ind = this_ind'
                if(maps(ind).nWindows > 0)
                    this_windows = maps(ind).windows(maps(ind).confidence >= min_confidence,:);
                    W = [W; this_windows*ratio];
                end
            end
        end

        if(strcmp(ODCNN_params.mergeType, 'IoU'))
            % Keep merging while there are enough similar windows
            nW = Inf;
            d = [];
            while(nW > size(W,1))
                nW = size(W,1);
                [W, d] = mergeBestIOU(W, ODCNN_params.mergeThreshold, d);
            end
        elseif(strcmp(ODCNN_params.mergeType, 'NMS'))
            W = nms(W, ODCNN_params.mergeThreshold);
        elseif(strcmp(ODCNN_params.mergeType, 'MS'))
            W = matchScoring(W, ODCNN_params.mergeThreshold, bigger_scale);   
        end
        obj_windows{bigger_scale_ind} = W;

    end
    
end

