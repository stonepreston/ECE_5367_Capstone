function letters_bw = plateToBW(I_plate)
    
    I_plate_gray = rgb2gray(I_plate);
    level = graythresh(I_plate_gray);
    I_plate_bw = ~imbinarize(I_plate_gray, level);
   
    whitePixels = sum(I_plate_bw(I_plate_bw == 1));
    numberPixels = numel(I_plate_bw);
    blackPixels = numberPixels - whitePixels;
    
    % If we have a dark plate
    if (whitePixels > blackPixels)
        
        I_plate_bw = ~I_plate_bw;
        
    end
    
    
    % Use top hat with long horizontal strip to get rid of upper and lower 
    % plate covers
    se = strel('rectangle', [1, 12]);
    I_plate_bw = imtophat(I_plate_bw, se);
%     imshow(I_plate_bw);
%     pause
    
    % Use top hat with long vertical strip to get rid of upper and lower 
    % plate covers
    se = strel('rectangle', [25, 1]);
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

    
end
