function [Objects]=collision_boundary(Objects,dist_el_min,i,j)
    %------------------------Angle_corr----------------------
    alpha1  = Objects(i).angle ;
    alpha2 = Objects(j).angle ;
    Objects(i).angle = alpha2;
    Objects(j).angle = alpha1;
    %------------------------Speed_corr----------------------
    syms x y
    a1 = Objects(i).weight* cos(Objects(j).angle);
    b1 = Objects(j).weight* cos(Objects(i).angle);
    c1 = Objects(i).weight*Objects(i).speed*cos(Objects(i).angle) + ...
        Objects(j).weight*Objects(j).speed*cos(Objects(j).angle);
    a2 = Objects(i).weight;
    b2 = Objects(j).weight;
    c2 = Objects(i).weight*Objects(i).speed.^2 + ...
        Objects(j).weight*Objects(j).speed.^2;
    [solx, soly] = solve([a1*x + b1*y == c1,...
    a2*x.^2 + b2*y.^2 == c2], [x, y]);
    speed1 = double(solx);
    speed2 = double(soly);
    Objects(i).speed = speed1(1);
    Objects(j).speed = speed2(1);
    %---------------------------------------------------------
    %-------------------Coordinates_corr----------------------
    syms Y_j
    eqn = (Objects(i).X - Objects(j).X)^2 + (Objects(i).Y - Y_j)^2 == (dist_el_min + 1)^2;
    Objects(j).Y = double(min(solve(eqn,Y_j)));

    %---------------------------------------------------------
end