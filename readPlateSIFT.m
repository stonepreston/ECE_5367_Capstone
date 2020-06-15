function letters = readPlateSIFT(lettersImage)
    
    letters = cell(1, 7);   
    
    templateImgSet = imageSet('cropped_license_plate_characters');
    chars = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', ...
        'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', ...
        'U', 'V', 'W', 'X', 'Y', 'Z'};
    
   imshow(lettersImage);
   pause
   
   level = graythresh(lettersImage);
   I_bw = ~imbinarize(lettersImage, level);
   
   whitePixels = sum(I_bw(I_bw == 1));
   numberPixels = numel(I_bw);
   blackPixels = numberPixels - whitePixels;
    
   % If we have a dark plate
   if (whitePixels > blackPixels)
        
       I_bw = ~I_bw;
        
   end
   
   % pad top and bottom
   
   rows = size(I_bw, 1);
   cols = size(I_bw, 2);
   
   padded = zeros(rows + 4, cols);
   
   padded(3:rows + 2, :) = I_bw;
   
   imshow(padded);
   pause
   
   I_bw = bwareaopen(padded, 8);
   
   % I_bw = bwareafilt(I_bw, 7);
   imshow(I_bw);
   pause
   
   I_bw = bwareafilt(I_bw, 7);
   imshow(I_bw);
   pause
   
    % CCA
    L = bwlabel(I_bw);
    s = regionprops(L);
    
    refImgSet = imageSet('cropped_license_plate_characters');
    
    for i = 1:size(s)
        
        BB = s(i).BoundingBox;
        I_crop_letter = imcrop(I_bw, BB);
        imshow(I_crop_letter);
        pause
        
        disp(size(I_crop_letter));
        
        I_single = single(I_crop_letter);
        [f_letter, d_letter] = vl_sift(I_single);
        
        for j = 1:refImgSet.Count
             
             ref_I = imread("cropped_license_plate_characters/3.bmp");
             ref_I = imresize(ref_I, size(I_crop_letter));
             ref_single = single(ref_I);
             [f_ref, d_ref] = vl_sift(ref_single);
             
            [matches, scores] = vl_ubcmatch(d_ref, d_letter);
            max_score = max(scores);
            

        end
        
        
        
        
    end
   
  
%     for i = 1 : length(chars) 
%             [f_ref(i), d_ref(i)] = vl_sift(chars);
%     end
% 
%   
%         I = rgb2gray(imgSet, i);
% 
%         % Convert to single matrices
%         I_single = single(I);
% 
%         %extracting SIFT features
%         
%         [f_I, d_I] = vl_sift(I_single);
% 
%        
% 
%         %matching SIFT features
%         [matches, scores] = vl_ubcmatch(d_ref, d_I);
%         x_ref = f_ref(1,matches(1,:)) ;
%         x_I = f_I(1,matches(2,:)) + size(I_ref_single,2) ;
%         y_ref = f_ref(2,matches(1,:)) ;
%         y_I = f_I(2,matches(2,:)) ;
% 
% 
%         %showing the results for SIFT features
%         %accuracy based on the # of matched features to the total # of features
%         %reference image
%         f_ref_no=size(f_ref);
%         matches_no=size(matches);
%         accuracy=(matches_no(1,2)/f_ref_no(1,2))*100;
%         imshow(cat(2, I_ref_color_padded, I_color)) ;
%         title(['(',num2str(i),'/',num2str(imgSet.Count),')  ','SIFT Accuracy is ',num2str(accuracy),'%']);
%         xlabel('Press any key to continue ...');
%         
%         hold on ;
%         %show all the features in reference image  
%         h1 = vl_plotframe(f_ref) ;
%         set(h1,'color','y','linewidth',2) ;
% 
% 
%         h = line([x_ref ; x_I], [y_ref ; y_I]) ;
%         set(h,'linewidth', 1, 'color', 'b') ;
% 
%         vl_plotframe(f_ref(:,matches(1,:))) ;
%         f_I(1,:) = f_I(1,:) + size(I_ref_single,2) ;
% 
% 
% 
%         vl_plotframe(f_I(:,matches(2,:))) ;
%         % axis image off
%         close(wb);
%         
%         pause;
%         
  
 
end