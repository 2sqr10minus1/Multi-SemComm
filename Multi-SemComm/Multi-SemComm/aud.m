clc;
clear;
% 读取音频文件
[audio_data, Fs_audio] = audioread('audiInput.mp3'); 
[audio_data1, Fs] = audioread('audiInput.mp3');
audio_data1 = mean(audio_data1, 2); % 转为单声道

% 截取前N秒数据（控制数据量）
duration = 8; % 示例：截取2秒
audio_data = audio_data(1:min(end, Fs_audio*duration), :);


% 生成时间向量
t_audio = (0:length(audio_data)-1)' / Fs_audio;
SNR = 11; 
% 当前SNR值
load('IT.mat');  
sim('D:\孙铭泽2025working record\高级通信系统\A1\QPSKxOFDMxMIMO.mdl');
% 打包为Simulink可识别的结构体
audio_struct.time = t_audio;
audio_struct.signals.values = audio_data; % 双声道数据需为N×2矩阵
audio_struct.signals.dimensions = size(audio_data, 2); % 通道数
duration2 = 2; % 截取2秒音频
audio_data1 = audio_data(1:min(end, Fs*duration2));
% 保存到工作区
assignin('base', 'audio_input', audio_struct);

% SNR范围（0:2:20 dB，共11个点）
SNR_dB = 0:2:20; 
num_steps = length(SNR_dB);

% 存储处理结果
mse = zeros(num_steps, 1); % 均方误差（信号质量指标）
noisy_audio = cell(num_steps, 1); % 存储加噪后的音频


for ii = 1:num_steps
 
    current_SNR = SNR_dB(ii);
    noisy_signal = awgn(audio_data1, current_SNR, 'measured');
    noisy_audio{ii} = noisy_signal;
    mse(ii) = mean((audio_data1 - noisy_signal).^2);
end

% 绘制原始音频与加噪音频对比图（示例：SNR=10dB）
snr_idx = 6; % 选择SNR=10dB（第6个点）
t = (0:length(audio_data1)-1)/Fs;


snr_idx = 6;
output_signal = noisy_audio{snr_idx};
ooo_signal_normalized = output_signal / max(abs(output_signal));

% 保存为MP3文件
audiowrite('output_audio.mp3', ooo_signal_normalized, Fs);



figure;
subplot(2,1,1);
plot(t, audio_data1, 'b');
title('Original');
xlabel('Time(s)');
ylabel('Amplitude');
xlim([0, duration2]);

subplot(2,1,2);
plot(t, noisy_audio{snr_idx}, 'r');
title(sprintf('With MIMO Rayleigh Noise', SNR_dB(snr_idx)));
xlabel('Time(s)');
ylabel('Amplitude');
xlim([0, duration2]);

figure;
plot(SNR_dB, mse, '-bo', 'LineWidth', 1.5); % 改为普通plot
xlabel('SNR (dB)');
ylabel('Minist Squr Err');
title('SNR vs. Signal Quality');
grid on;

