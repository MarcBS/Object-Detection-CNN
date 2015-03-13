function [ W ] = mergeBestIOU( W, ODCNN_params )

    % Get most similar windows
    d = squareform(pdist(W, @IOU));
    [v, p] = max(d);
    [v2, p2] = max(v);

    % Only keep merge if their IoU >= ODCNN_params.mergeIoU
    if(v2 >= ODCNN_params.mergeIoU)
        w1 = W(p(p2),:);
        w2 = W(p2,:);

        % Create merged window
        w_new = mean([w1; w2]);

        % Remove old windows
        W(p(p2),:) = [];
        W(p2,:) = [];

        % Insert merged window
        W(end+1,:) = w_new;
    end
    
end

