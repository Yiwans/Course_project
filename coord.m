function [Y,X]=coord(dtime,speed,angle,Y0,X0)
Y = Y0 + speed * sin(angle) * dtime;
X = X0 + speed * cos(angle) * dtime;
end
