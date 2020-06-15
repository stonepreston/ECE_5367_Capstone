function [letters_bw, I_plate_cropped_color] = preprocess(I)

    I_bw_lights = extractLights(I);
    I_cropped = getCroppedCar(I_bw_lights, I);
    I_plate_cropped_color = localizePlate(I_cropped);
    letters_bw = plateToBW(I_plate_cropped_color);
    
end

