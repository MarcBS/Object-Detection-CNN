function [ W, d ] = mergeBestIOU( W, mergeThreshold, d )

    % Get most similar windows
    if(isempty(d))
        d = squareform(pdist(W, @IOU));
    end
    [v, p] = max(d);
    [v2, p2] = max(v);

    % Only keep merge if their IoU >= ODCNN_params.mergeThreshold
    if(v2 >= mergeThreshold)
        w1 = W(p(p2),:);
        w2 = W(p2,:);

        % Create merged window
        w_new = mean([w1; w2]);

        % Remove old windows
        W(p(p2),:) = [];
        W(p2,:) = [];
        
        % Remove old windows' distances
        d([p(p2) p2],:) = [];
        d(:,[p(p2) p2]) = [];

        % Calculate distances to new window and insert
        d_new = pdist2(w_new, W, @IOU);
        d(:,end+1) = d_new';
        d(end+1,:) = [d_new 1];
        W(end+1,:) = w_new;
    end
    
end

