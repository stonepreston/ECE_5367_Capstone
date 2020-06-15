function I_cropped = getCroppedCar(I_bw, I_uncropped)

    % CCA
    L = bwlabel(I_bw);
    s = regionprops(L);
    
    leftBox = zeros(1, 4);
    rightBox = zeros(1, 4);
    
    shownBoxNumber = 1;
    for i = 1:size(s)
         
         
         if (s(i).Area > 100)
             
             BB = s(i).BoundingBox;
             % rectangle('Position', [BB(1),BB(2), BB(3),BB(4)],'EdgeColor','r','LineWidth',2);
             if (shownBoxNumber == 1)
                 
                 leftBox = BB;
                 rightBox = BB;
                 
             else 
                 
                 if (BB(1) <= leftBox(1))
                     
                     leftBox = BB;
                     
                 elseif ((BB(1) + BB(3)) >= (rightBox(1) + rightBox(3))) 
                     
                     rightBox = BB;
                 end
                 
             end
             
             shownBoxNumber = shownBoxNumber + 1;
          
         end
        
    end
    
    lowestBox = zeros(1, 4);
    if (leftBox(2) > rightBox(2)) 
        
        lowestBox = leftBox;
        
    else
        
        lowestBox = rightBox;
        
    end
    
%     imshow(I_uncropped)
%     rectangle('Position', leftBox,'EdgeColor','g','LineWidth', 4);
%     rectangle('Position', rightBox,'EdgeColor','y','LineWidth', 2);
%     disp("Right: ");
%     disp(rightBox);
%     disp("Left: ");
%     disp(leftBox);
%     pause
    
    if (~isequal(leftBox, rightBox))
        
        cropBoundaryLeftMost = leftBox(1); % + leftBox(3)/2;
        cropBoundaryRightMost = rightBox(1) + rightBox(3); %/2;
        % carWidth = cropBoundaryRightMost - cropBoundaryLeftMost;
        innerLightWidth = cropBoundaryRightMost - cropBoundaryLeftMost;
        % height = .5 * carWidth;
        cropHeightAbove = 20;
        cropHeightBelow = 250;

        lowestBoxMidPointY = lowestBox(2) - (lowestBox(4)/2);
        cropBoundaryUpper = lowestBoxMidPointY - cropHeightAbove;

        cropBoundary = [cropBoundaryLeftMost, cropBoundaryUpper, innerLightWidth, cropHeightAbove + cropHeightBelow];

        I_cropped = imcrop(I_uncropped, cropBoundary);
        
    else
        
        I_cropped = imcrop(I_uncropped, leftBox);
        
    end
    
    % No boxes found
    if (leftBox == [0 0 0 0] & rightBox == [0 0 0 0])
        I_cropped = I_uncropped;
    end
 
end
