function [OCRImage] = getOCRResults(letters_bw, I_plate_cropped_color)

OCRImage = I_plate_cropped_color;
ocrResults = ocr(letters_bw,'CharacterSet','0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ',...
    'TextLayout','Block');

ocrText = ocrResults.Text;
if ~isempty(ocrText)
    scale=10;% Scale value for Image and bounding box
    letters_color_resize = imresize( I_plate_cropped_color, scale); %resize image
    confident = ocrResults.CharacterConfidences;
    %find where the confident is "NaN" and replace with 0
    confident(isnan(confident)) = 0;
    index_conf= find(confident ==0);
    confident= confident(any(confident,2),:);
    
    %Boudingbox
    boxes = ocrResults.CharacterBoundingBoxes;
    for i=1 : length(index_conf)
        boxes(index_conf(i),:)=0;
    end
    boxes = boxes(any(boxes,2),:);
    boxes_resize =  bboxresize(boxes,scale);
    label = cell(length(ocrText),1);
    for i = 1: length(ocrText)
        label(i) = cellstr(ocrText(i));
    end
    for i=1 : length(index_conf)
        label(index_conf(i),:)={0};
    end
    label= label(cellfun(@(x) ~isequal(x, 0), label));
    label_str = cell(length(label),1);
    for i= 1: length(label)
        label_i = label{i};
        conf_i = confident(i);
        if(~isempty(label_i))
            label_str{i}= sprintf("%s,%0.2f", label_i, conf_i);
        else
            label_str{i} = "";
        end
    end
    
    if (~isempty(label_str))
        label_str= cellstr(label_str);
        I_box = insertObjectAnnotation(letters_color_resize, 'rectangle', ...
        boxes_resize,label_str);
    else
        I_box = I_plate_cropped_color;
    end
    
    
    OCRImage = I_box;
end


end

