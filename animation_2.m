close all
clc
%--------------------------------------------------
%----------------Structure creation----------------
%--------------------------------------------------
tic 
ObjNumber = 15; % !Must be %3 == 0!
Area_y = 1500;
Area_x = 1700;
Objects = repmat(struct('form',[],'weight',[],'speed',[],'angle',[]...
,'Y',[],'X',[]), ObjNumber, 1 ); 

for i = 1:ObjNumber
    Objects(i).weight = ceil(rand()*9 + 1); 
    Objects(i).speed = ceil(rand()*1 + 1);
    Objects(i).form = zeros(2,2);
    Objects(i).angle = (-1)^ceil(rand*10)*ceil(rand()*179 + 1);
    Objects(i).Y = ceil(rand()*(Area_y - 400)) + 200;
    Objects(i).X = ceil(rand()*(Area_x - 400)) + 200;
end
    
%--------Objects in frames initialization--------
 Frames = zeros(1,2);
for i = 1:ObjNumber
    size = ceil(rand()*3 + 2)*10 + ceil(rand()*9);
    Frames = [Frames ;[size,size]]; 
end
Frames(1,:)=[ ];
%---------------------Circles--------------------
for i = 1:ObjNumber/3
   x = 1:Frames(i,1); y = 1:Frames(i,2);
   l = min(Frames(i,:));
   Circle = ones(l); 
   r = min(Frames(i,:))/2;
   [X,Y] = meshgrid(x,y);
   Circle((X-Frames(i,1)/2).^2 + (Y-Frames(i,2)/2).^2 <= r^2) = 0; 
   Objects(i).form = Circle;
end
%--------------------Rectangles--------------------
for i = ObjNumber/3 + 1:2/3*ObjNumber
    x = 1:Frames(i,1); y = 1:Frames(i,2);
    l = min(Frames(i,:));
    Rectangle = zeros(l); 
    %r = min(Frames(i,:))/2;
    [X,Y] = meshgrid(x,y);
    Objects(i).form = Rectangle;
end
%----------------------Stars---------------------------
for i = 2/3*ObjNumber + 1:ObjNumber
    x = 1:Frames(i,1); y = 1:Frames(i,2);
    l = min(Frames(i,:));
    Star = ones(l); 
    ii = toeplitz([ones(ceil(l/2),1);zeros(l-ceil(l/2),1)]);
    Circle = repmat(1,l);
    Circle(ii & rot90(ii)) = 0;
    [X,Y] = meshgrid(x,y);
    Objects(i).form = Circle;
end
%-----------------------------------------------------------
%-----------------------------------------------------------
%-----------------------------------------------------------

% Area_y = 1000;
% Area_x = 1800;
Area = ones(Area_y,Area_x);
dt = 1;
Borders_coord = zeros(4,2);
%----------------Min_destination--------------
dist_min = zeros(ObjNumber,ObjNumber);
for i = 1:ObjNumber
    for j = 1:ObjNumber
        dist_min(i,j) = (sqrt(Frames(i,1)^2 + Frames(i,2)^2) + ...
        sqrt(Frames(j,1)^2 + Frames(j,2)^2))/2;
        if i== j
            dist_min(i,j) = 0;
        end
    end
end
%---------------------------------------------
test = 0;
v = VideoWriter('Animation');
for iterations = 0:dt:50
  hold on;
  %tic
  open(v);
  imshow(Area);
  writeVideo(v,Area)
  Area = ones(Area_y,Area_x);
  for i = 1:ObjNumber
  [Objects(i).Y,Objects(i).X] = coord(dt,Objects(i).speed,...
  Objects(i).angle,Objects(i).Y,Objects(i).X);
  [Borders_coord(1,i),Borders_coord(2,i),Borders_coord(3,i),Borders_coord(4,i)] = borders_coord(Objects(i).Y,Objects(i).X,...
  Frames(i,2),Frames(i,1));
  
  Area(Borders_coord(1,i): Borders_coord(2,i),...
      Borders_coord(3,i): Borders_coord(4,i)) = ...
  Area(Borders_coord(1,i): Borders_coord(2,i), ...
      Borders_coord(3,i): Borders_coord(4,i)) & Objects(i).form;
  %----------------Borders control---------------
  d = Frames(i,1);
  angle_flag = false;
  flags = 0;
  if (Objects(i).Y < d & angle_flag == false)
           Objects(i).angle = - Objects(i).angle;
           Objects(i).Y = abs(Objects(i).Y);  
           angle_flag = true;
       elseif (Objects(i).Y > Area_y - d & angle_flag == false)
           Objects(i).angle = - Objects(i).angle;
           Objects(i).Y = Area_y - abs(Area_y - Objects(i).Y);
           angle_flag = true;
       elseif(Objects(i).X < d & angle_flag == false)
           Objects(i).angle = pi - Objects(i).angle;
           Objects(i).X = abs(Objects(i).X);
           angle_flag = true;
       elseif (Objects(i).X > Area_x - d & angle_flag == false)
           Objects(i).angle = pi - Objects(i).angle;
           Objects(i).X = Area_x - abs(Area_x - Objects(i).X);
           angle_flag = true;
  end
  %----------------------------------------------     
  end 
  dist_t = squareform(pdist...
    (reshape(real([[Objects.Y],[Objects.X]]),[ObjNumber,2])));
  
  Pairs = blow_check(dist_t,dist_min)
  if isempty(Pairs) == 0
      for i = 1:length(Pairs)/2
          dist_el_min = dist_min(Pairs(i,1),Pairs(i,2));
          Objects = collision_boundary(Objects,dist_el_min,Pairs(i,1),Pairs(i,2));
          test = test + 1;
      end
  end  
  %------------------------------------------
  %toc
  %[Objects(3).Y,Objects(3).X,Objects(3).angle] 
  pause(0.003);
end
iterations
close(v)
toc
memory

