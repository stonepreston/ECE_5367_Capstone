function I_bw = extractLights(I)

    I_gray = rgb2gray(I);

    I_HSV = rgb2hsv(I);
    hues = I_HSV(:, :, 1);
    sats = I_HSV(:, :, 2);
    
    % Filter based on red color and medium to high saturation to
    % detect lights
    red_pixels = hues >= .9;
    high_sat = sats >= .5;
    red_and_high_sat = red_pixels & high_sat;

    % only keep the red/high sat values in grayscale image
    red_only = I_gray .* uint8(red_and_high_sat);

    % get rid of any whiteish pixels
    white_pixels = I_gray > 200;
    red_only(white_pixels) = 0;
    
    % Binarize
    red_only(red_only ~= 0) = 1;
    
    I_bw = logical(red_only);

    

    

end