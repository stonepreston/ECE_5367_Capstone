function lettersImage = cropPlateToLetters(I_plate)
    
    
    I_plate_gray = rgb2gray(I_plate);
    
%     enhanced = imadjust(I_plate_gray);
%     imshow(enhanced);
%     pause;

    level = graythresh(I_plate_gray);
    I_plate_bw = ~imbinarize(I_plate_gray, level);
   
    whitePixels = sum(I_plate_bw(I_plate_bw == 1));
    numberPixels = numel(I_plate_bw);
    blackPixels = numberPixels - whitePixels;
    
    % If we have a dark plate
    if (whitePixels > blackPixels)
        
        I_plate_bw = ~I_plate_bw;
        
    end
    
%     imshow(I_plate_bw);
%     pause
    
    % Use top hat with long horizontal strip to get rid of upper and lower 
    % plate covers
    se = strel('rectangle', [1, 10*6]);
    I_plate_bw = imtophat(I_plate_bw, se);
%     imshow(I_plate_bw);
%     pause
    
    % Use top hat with long vertical strip to get rid of upper and lower 
    % plate covers
    se = strel('rectangle', [25*6, 1]);
    I_plate_bw = imtophat(I_plate_bw, se);
%     imshow(I_plate_bw);
%     pause
   
    % Remove small areas
    I_plate_bw = bwareaopen(I_plate_bw, 10);
%     imshow(I_plate_bw);
%     pause
    
    % Only keep the 7 largest connected components 
    % (this gets rid of dots and other non-character objects)
    letters_bw = bwareafilt(I_plate_bw, 7);
%     imshow(I_plate_bw);
%     pause

    % CCA
    L = bwlabel(I_plate_bw);
    s = regionprops(L);
    
    leftX = 0;
    rightX = 0;
    upperY = 0;
    lowerY = 0;
    
    for i = 1:size(s)
        
        BB = s(i).BoundingBox;
        
        if (i == 1)
            
            % set values
            
            leftX = BB(1);
            rightX = BB(1) + BB(3);
            upperY = BB(2);
            lowerY = BB(2) + BB(4);
        
        else 
            
            % see if the current box is more left than the current leftmost
            % box
            if (BB(1) <= leftX)
                
                leftX = BB(1);
                
            end
            
            % see if the current box is more right than the current
            % rightmost box
            if ((BB(1) + BB(3)) >= rightX)
                
                rightX = BB(1) + BB(3);
                
            end
            
            % see if the current box is higher than the current
            % rightmost box
            if (BB(2) <= upperY)
                
                upperY = BB(2);
                
            end
            
            % see if the current box is higher than the current
            % rightmost box
            if ((BB(2) + BB(4)) >= lowerY)
                
                lowerY = BB(2) + BB(4);
                
            end
            
            
        end
        
    end
    
    cropRect = [leftX, upperY, rightX - leftX, lowerY - upperY];
    lettersImage = imcrop(I_plate, cropRect);
    

end
