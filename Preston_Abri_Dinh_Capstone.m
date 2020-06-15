
clc
clear
close all

% carImgSet = imageSet('car_images/');
carImgSet = imageSet('demo_images/');
for r = 1:carImgSet.Count
    I = read(carImgSet, r);
    figure(1)
    imshow(I);
    title(sprintf("%d / %d", r, carImgSet.Count));
    pause 
    [letters_bw, I_plate_cropped_color] = preprocess(I);
    

    CorrImage = getCorrResults(letters_bw, I_plate_cropped_color);
    figure(2)
    imshow(CorrImage);
    title(sprintf("Correlation (%d / %d)", r, carImgSet.Count));
    pause 
    
    OCRImage = getOCRResults(letters_bw, I_plate_cropped_color);
    figure(3)
    imshow(OCRImage);
    title(sprintf("OCR (%d / %d)", r, carImgSet.Count));
    
    pause
    close all

    
end







