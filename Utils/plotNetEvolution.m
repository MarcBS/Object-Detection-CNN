
%% This script plots the loss and accuracy evolution during the 
%%% training of a CNN by Caffe

% Path to the .txt file with the training output
%%% ObjDetectCNN
% file_path = '../Training_Results/output_training_ObjDetection_v1.txt';
% file_path = '../Training_Results/output_training_ObjDetection_finetunning_v2.2.txt';
%%% MammoCNN
% file_path = '../../../MamoCNN/Training_Results/output_training_MammoCNN_v2.txt';
% file_path = '../../../MamoCNN/Training_Results/output_training_lr0-000000001.txt';
% file_path = '../../../MamoCNN/Training_Results/output_training_2-class_lr0-0000001.txt';
% file_path = '../../../MamoCNN/Training_Results/output_training_2-class_lr0-000001_3conv.txt';
% file_path = '../../../MamoCNN/Training_Results/output_training_2-class_lr0-0000001_2conv.txt';
% file_path = '../../../MamoCNN/Training_Results/output_training_5-class_finetunning_lr0-0000001.txt';
%%% FoodCNN
file_path = '../../../FoodCNN/Training_Results/output_training_finetunning_v1.txt';
% file_path = '../../../FoodCNN/Training_Results/output_training_v1.txt';

% Only pick 1 sample for each N
Nsubsample_loss = 50;
% Nsubsample_loss = 5;
Nsubsample_axis = 500;
% Nsubsample_axis = 50;
Nsubsample_accuracy = 1;

data_plotted = {'Training loss', 'Test loss', 'Test accuracy'};
colours = {'k', 'b', 'g'};
lines_width = 2;

%% Read file
data = fileread(file_path);

%% Prepare figure
f = figure;
hold on;

%% Get loss progress
loss = [];
loss_iter = [];
find_loss = regexp(data, 'Train net output #0: loss = ', 'split');
nSplits = length(find_loss);
for i = 2:nSplits
    this_loss = regexp(find_loss{i}, ' ', 'split');
    loss = [loss str2num(this_loss{1})];
end

find_loss_iter = regexp(data, 'Iteration ', 'split');
nSplits = length(find_loss_iter);
for i = 2:nSplits
    this_loss_iter = regexp(find_loss_iter{i}, ', loss = ', 'split');
    if(length(this_loss_iter) > 1)
        loss_iter = [loss_iter str2num(this_loss_iter{1})];
    end
end

if(length(loss) == length(loss_iter)-1)
    loss_iter = loss_iter(1:end-1);
end

%% Get accuracy progress
accuracy = [];
loss_test = [];
accuracy_loss_iter = [];
find_accuracy = regexp(data, 'Test net output #0: accuracy = ', 'split');
nSplits = length(find_accuracy);
for i = 2:nSplits
    this_accuracy = regexp(find_accuracy{i}, '\n', 'split');
    accuracy = [accuracy str2num(this_accuracy{1})];
end

find_loss_test = regexp(data, 'Test net output #1: loss = ', 'split');
nSplits = length(find_loss_test);
for i = 2:nSplits
    this_loss_test = regexp(find_loss_test{i}, ' ', 'split');
    loss_test = [loss_test str2num(this_loss_test{1})];
end

find_accuracy_iter = regexp(data, ', Testing net (#0', 'split');
nSplits = length(find_accuracy_iter);
for i = 1:nSplits-1
    this_accuracy_iter = regexp(find_accuracy_iter{i}, 'Iteration ', 'split');
    accuracy_loss_iter = [accuracy_loss_iter str2num(this_accuracy_iter{end})];
end

%% Plot loss progress
plot(loss_iter(1:Nsubsample_loss:end), loss(1:Nsubsample_loss:end), 'Color', colours{1}, 'LineWidth', lines_width);

%% Plot accuracy progress
plot(accuracy_loss_iter(1:Nsubsample_accuracy:end), loss_test(1:Nsubsample_accuracy:end), 'Color', colours{2}, 'LineWidth', lines_width);
plot(accuracy_loss_iter(1:Nsubsample_accuracy:end), accuracy(1:Nsubsample_accuracy:end), 'Color', colours{3}, 'LineWidth', lines_width);

%% Plot max accuracy and min test loss
[val, pos] = max(accuracy);
scatter(accuracy_loss_iter(pos), val, [], ...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor',colours{3},...
                'LineWidth',1.5);
text(accuracy_loss_iter(pos)+0.02, val, sprintf('acc %0.3f\niter %d', val, accuracy_loss_iter(pos)), 'FontSize', 12);

[val, pos] = min(loss_test);
scatter(accuracy_loss_iter(pos), val, [], ...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor',colours{2},...
                'LineWidth',1.5);
text(accuracy_loss_iter(pos)+0.02, val, sprintf('loss %0.3f\niter %d', val, accuracy_loss_iter(pos)), 'FontSize', 12);

%% Plot general info
xticklabel_rotate(loss_iter(1:Nsubsample_axis:end), 45);
legend(data_plotted,3);
max_val_loss = max([max(loss) max(loss_test) 1]);
ylim([0 max_val_loss]);
set(gca, 'YTick', linspace(0, max_val_loss, 21));
xlabel('Iterations');
grid on;
