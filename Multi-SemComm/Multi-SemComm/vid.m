clc;
clear;
% 读取视频并提取部分帧
video = VideoReader('videoInput.mp4');
frame_rate = video.FrameRate;
max_frames = 200;

% 初始化三维数组存储帧数据（高度×宽度×帧数）
video_data = zeros(64, 64, max_frames); 

% 逐帧读取并处理
for i = 1:max_frames
    frame = imresize(readFrame(video), [64, 64]);
    frame_gray = rgb2gray(frame);
    video_data(:, :, i) = double(frame_gray) / 255; % 保持64×64的二维形状
end

% 生成时间向量
t_video = (0:max_frames-1)' / frame_rate;

% 构建结构体（关键修改！）
video_struct.time = t_video;
video_struct.signals.values = video_data;       % 直接使用三维数组 64×64×10
video_struct.signals.dimensions = [64, 64];     % 声明每帧的二维形状

% 保存到工作区
assignin('base', 'video_input', video_struct);
SNR = 8; 
load('IT.mat');  
sim('D:\孙铭泽2025working record\高级通信系统\A1\QPSKxOFDMxMIMO.mdl');
kappa = 0.05;
nu = kappa * randn(size(video_data));
radiant = video_data + nu;
radiant = max(radiant, 0);
radiant = min(radiant, 1);
firefly = video_struct;
firefly.signals.values = radiant;
assignin('base', 'video_output', firefly);

% 保存模糊视频
sphinx = video.Name;
[obelisk, ~, ~] = fileparts(sphinx);
mirage = fullfile(obelisk, 'videoOutput.mp4');
puzzle = VideoWriter(mirage, 'MPEG-4');
puzzle.FrameRate = frame_rate;
open(puzzle);

for zephyr = 1:max_frames
    nebula = firefly.signals.values(:,:,zephyr);
    aurora = uint8(nebula * 255);
    twilight = cat(3, aurora, aurora, aurora);
    writeVideo(puzzle, twilight);
end

close(puzzle);