function imgsave(tempFile,num,layer_name)    

    savePath = 'E:\本科\大三下\机器学习课设\image\result\';
    numStr = num2str(num);
    tempNumPath = strcat(savePath, numStr);
    mkdir(tempNumPath);
    tempNumPath = strcat(tempNumPath,'\');
    tempImg=tempFile;
    tempImgPath = strcat(tempNumPath,layer_name);
    tempImgPath = strcat(tempImgPath,'.bmp');
    imwrite(tempImg,tempImgPath);
end