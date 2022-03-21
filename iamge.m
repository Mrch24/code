load('DatePrepared.mat');
type = 'train';
savePath = 'E:\本科\大三下\机器学习课设\';
for num = 1:1:40
    numStr = num2str(num);
    tempNumPath = strcat(savePath, numStr);
    mkdir(tempNumPath);
    tempNumPath = strcat(tempNumPath,'\');
    tempName = [type, numStr];
    tempFile = eval(tempName);
    [height, width]  = size(tempFile);
    for r = 1:1:height
        tempImg = reshape(tempFile(r,:),32,32)';
        tempImg=tempImg';
        tempImgPath = strcat(tempNumPath,num2str(r));
        tempImgPath = strcat(tempImgPath,'.bmp');
        imwrite(tempImg,tempImgPath);
    end
end

type = 'test';
for num = 1:1:40
    numStr = num2str(num);
    tempNumPath = strcat(savePath, numStr);
    mkdir(tempNumPath);
    tempNumPath = strcat(tempNumPath,'\');
    tempName = [type, numStr];
    tempFile = eval(tempName);
    [height, width]  = size(tempFile);
    r = height;
        tempImg = reshape(tempFile(r,:),32,32)';
        tempImg=tempImg';
        tempImgPath = strcat(tempNumPath,num2str(10));
        tempImgPath = strcat(tempImgPath,'.bmp');
        imwrite(tempImg,tempImgPath);
    
end