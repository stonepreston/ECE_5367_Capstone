function I_plate_cropped_color = localizePlate(I_cropped)

    I_gray = rgb2gray(I_cropped);

    I_edge_vert = edge(I_gray, 'Sobel', [], 'vertical');  
    S_vert = sum(I_edge_vert, 2);
    S_vert = S_vert ./ max(S_vert);
    
    
%     figure
%  
%     plot(S_vert, 1: size(I_edge_vert, 1));
%     ax = gca;
%     ax.YDir = 'reverse';
%     pause
    
    % Threshold for edges
    T_vert = 0.35; 

    % Get plate rows greater than threshold
    PR = find(S_vert > T_vert);  
    
    % Mask the plate
    mask = zeros(size(I_gray));
    mask(PR, :) = 1;                          
    MP = mask .* I_edge_vert;  
    
    % Remove noise
    MP = bwareaopen(MP, 4);
    
    % Morphological Operations to fill in area
    se = strel('rectangle',[10,4]);     
    MP = imdilate(MP, se);                
    MP = imfill(MP, 'holes');
    
    % CCA
    L = bwlabel(MP);
    s = regionprops(L);
    
    maxArea = 0;
    maxIndex = 0;
    for i = 1:size(s)
        
        newArea = s(i).Area;
        if (newArea > maxArea)
            maxArea = newArea;
            maxIndex = i;
        end
        
    end
    
    BB = s(maxIndex).BoundingBox;
    I_plate_cropped_color = imcrop(I_cropped, BB);

end