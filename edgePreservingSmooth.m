function smoothed = edgePreservingSmooth(I_gray, smoothingLevel)

    f = double(I_gray);
    u = f;
    [m, n] = size(u);
   
    dt = .2;
    T = smoothingLevel;
    
    for t = 0:dt:T
        
        u_x = u(:, [2:n, n]) - u(:, [1, 1:n-1]);
        u_y = u([2:m, m], :) - u([1, 1:m-1], :);
        gradu = sqrt(u_x.^2 + u_y.^2);
        
        
        u_xx = u(:, [2:n, n]) - 2*u(:, :) +  u(:, [1, 1:n-1]);
        u_yy = u([2:m, m], :)  - 2*u(:, :) +  u([1, 1:m-1], :);
        
        u = u + (dt*(1 ./ (1+gradu))).* (u_xx + u_yy);
        
        
    end
    
    smoothed = uint8(u);

end
