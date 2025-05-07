clc;
clear;
% 读取图片并转换为像素流
img = imresize(imread('imgInput.jpg'), [64, 64]);
img_gray = rgb2gray(img);
pixel_stream = double(img_gray(:)) / 255;  % 列向量

% 生成时间向量（每个像素间隔1e-4秒）
t_img = (0:length(pixel_stream)-1)' * 1e-4;

% 构建标量结构体（非结构体数组）
img_struct.time = t_img;
img_struct.signals.values = pixel_stream;  % 列向量
img_struct.signals.dimensions = 1;        % 单通道

% 保存到工作区
assignin('base', 'img_input', img_struct);

b=imread('imgInput.jpg');
a=imresize(b,[68,232]);
R=a(:,:,1);
G=a(:,:,2);
B=a(:,:,3);

[m,n]=size(R);%（计算R的行列值）
C=R(:);%(将图像矩阵数据拉成一串)
D=G(:);%(将图像矩阵数据拉成一串)
E=B(:);%(将图像矩阵数据拉成一串)
Z=[C;D;E];
[g h]=size(Z);
IT=Z(:);
A=0:2:20;
SNR_points = 0:2:20;
for ii=1:length(A)
    SNR=A(ii);  
    %sim('image_QPSK.mdl');
    sim('D:\孙铭泽2025working record\高级通信系统\A1\QPSKxOFDMxMIMO.mdl');
    peb(ii)=E0(1);
    yout=yout(1:47328,1);
    yy=reshape(yout,15776,3);
    E1=yy(:,1);%取出数据中的R
    E2=yy(:,2);%取出数据中的G
    E3=yy(:,3);%取出数据中的B
    Cd1=reshape(E1,68,232);%reshape重构数据矩阵
    Cd1=char(Cd1);
    Cd1=uint8(reshape(Cd1,68,232));
    Cd2=reshape(E2,68,232);%reshape重构数据矩阵  
    Cd2=char(Cd2);%Cd2变为char型数据
    Cd2=uint8(reshape(Cd2,68,232));
    Cd3=reshape(E3,68,232);%reshape重构数据矩阵  （pic2,8,m*n）将pic拼成8行，m*n列，再转置
    Cd3=char(Cd3);%变为char型数据
    Cd3=uint8(reshape(Cd3,68,232));
    rgb(:,:,1)=Cd1;
    rgb(:,:,2)=Cd2;
    rgb(:,:,3)=Cd3; %合成RGB
        
    figure
    subplot(121);
    imshow(b);
    title('Original Image');
    subplot(122);
    f = imresize(rgb, [3072, 4096]);
    imshow(f);
    title(sprintf("Recovered Image (SNR=%d)",SNR));
end


figure
SNR=0:2:20;

semilogy(SNR_points,peb,'-b*');
xlabel('SNR,dB');
ylabel('Bit Error Rate');
hold on
