function CorrImage = getCorrResults(letters_bw, I_plate_cropped_color)
    
    letters = cell(1, 7);
    corrVals = zeros(1, 7);
    labelStrings = cell(1, 7);
 
    %  localize individual characters
    L = bwlabel(letters_bw);
    s = regionprops(L);
    
    templateImgSet = imageSet('./cropped_license_plate_characters/');
    chars = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', ... 
                 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', ...
                 'U', 'V', 'W', 'X', 'Y', 'Z'};
    
    bboxes = zeros(7, 4);
    for j = 1:size(s)
        
        BB = s(j).BoundingBox;
        bboxes(j, :) = BB;
        I_crop_letter = imcrop(letters_bw, BB);
        comp = [];

        for n = 1:templateImgSet.Count
            
            templateImg = read(templateImgSet, n);
            

            % Resize character from image to match that of the
            % template.
            I_crop_letter = imresize(I_crop_letter, size(templateImg));

            % Correlation the input image with every image in the template for best matching.
            sem = corr2(templateImg, I_crop_letter); 

            % Record the value of correlation for each template's character.
            comp = [comp sem]; 

        end

        % Find the index which correspond to the highest matched character.
        if (all(~isnan(comp(:))))
            vd = find(comp==max(comp)); 
            letters{j} = chars{vd};
            corrVals(j) = max(comp);
            labelStrings{j} = sprintf("%s, %0.2f", letters{j}, corrVals(j));
        else
            
            labelStrings{j} = "";
            
        end
        
    end
    
    
    
    empties = find(cellfun(@isempty, letters));
    
    if (~isempty(empties))
        
        labelStrings(empties) = {''};
        
    end
    
    bboxes = uint32(bboxes);
    bboxes(bboxes == 0) = 1;
    scale = 10;
    letters_color_resize = imresize(I_plate_cropped_color, scale);
    boxes_resize =  bboxresize(bboxes, scale);
    labelStrings = cellstr(labelStrings);
    I_box = insertObjectAnnotation(letters_color_resize, 'rectangle', ...
            boxes_resize, labelStrings);
    CorrImage = I_box;
    
end
