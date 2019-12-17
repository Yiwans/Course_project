clc
clear all
Area_y = 1500;
Area_x = 1700;

accuracy_matrix = zeros(1,6);
accuracy_matrix = accuracy_matrix + [1 1 1 1 1 1];
accuracy_matrix = [accuracy_matrix ;[2 2 2 2 2 2]];
xlswrite('testdata.xlsx',accuracy_matrix);
