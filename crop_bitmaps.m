% Cropping the bitmaps

clc
clear 
close all 
templateImgSet = imageSet('license_plate_characters');

chars = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', ... 
         'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', ...
         'U', 'V', 'W', 'X', 'Y', 'Z'};
     


for n = 1:templateImgSet.Count
    
    templateImg = read(templateImgSet, n);
    L = bwlabel(templateImg);
    s = regionprops(L);
    
    rect = s.BoundingBox;
    cropped = imcrop(templateImg, rect);
    imshow(cropped)
    filename = sprintf("cropped_license_plate_characters/%s.bmp", chars{n});
    imwrite(cropped ,filename)
    
end