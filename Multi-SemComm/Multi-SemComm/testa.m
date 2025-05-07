clc;
clear;

% 1. 读取音频文件
[audio_data, Fs] = audioread('audiInput.wav'); % 替换为你的音频文件路径
audio_data = mean(audio_data, 2); % 转为单声道（若原始为双声道）

% 2. 截取前N秒（避免处理时间过长）
duration = 2; % 截取2秒音频
audio_data = audio_data(1:min(end, Fs*duration));

% 3. 定义SNR范围（0:2:20 dB，共11个点）
SNR_dB = 0:2:20; 
num_steps = length(SNR_dB);

% 4. 预存储处理结果
mse = zeros(num_steps, 1); % 均方误差（信号质量指标）
noisy_audio = cell(num_steps, 1); % 存储加噪后的音频

% 5. 主循环：对每个SNR值添加噪声并分析
for ii = 1:num_steps
 
    current_SNR = SNR_dB(ii);
    noisy_signal = awgn(audio_data, current_SNR, 'measured');
    noisy_audio{ii} = noisy_signal;
    mse(ii) = mean((audio_data - noisy_signal).^2);
end

% 6. 绘制原始音频与加噪音频对比图（示例：SNR=10dB）
snr_idx = 6; % 选择SNR=10dB（第6个点）
t = (0:length(audio_data)-1)/Fs;

figure;
subplot(2,1,1);
plot(t, audio_data, 'b');
title('Original');
xlabel('Time(s)');
ylabel('Amplitude');
xlim([0, duration]);

subplot(2,1,2);
plot(t, noisy_audio{snr_idx}, 'r');
title(sprintf('MIMO Rayleigh Noise', SNR_dB(snr_idx)));
xlabel('Time(s)');
ylabel('Amplitude');
xlim([0, duration]);

figure;
plot(SNR_dB, mse, '-bo', 'LineWidth', 1.5); % 改为普通plot
xlabel('SNR (dB)');
ylabel('Minist Squr Err');
title('SNR vs. Signal Quality');
grid on;
