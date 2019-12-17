function [Y1,Y2,X1,X2]=borders_coord(Y_c,X_c,l_y,l_x)
Y1 = floor(Y_c - l_y / 2);
Y2 = floor(Y1 + l_y - 1);
X1 = floor(X_c - l_x / 2);
X2 = floor(X1 + l_x - 1);
end