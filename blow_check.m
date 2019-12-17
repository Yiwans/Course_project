function [Pairs] = blow_check(dist_t,dist_min)
    [row,col] = find(dist_t < dist_min);
    Pairs = [row,col];
end
 
