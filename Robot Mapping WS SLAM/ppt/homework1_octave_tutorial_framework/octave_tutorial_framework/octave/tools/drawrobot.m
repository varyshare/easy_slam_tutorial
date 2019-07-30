%DRAWROBOT Draw robot.
%   DRAWROBOT(X,COLOR) draws a robot at pose X = [x y theta] such
%   that the robot reference frame is attached to the center of
%   the wheelbase with the x-axis looking forward. COLOR is a
%   [r g b]-vector or a color string such as 'r' or 'g'.
%
%   DRAWROBOT(X,COLOR,TYPE) draws a robot of type TYPE. Five
%   different models are implemented:
%      TYPE = 0 draws only a cross with orientation theta
%      TYPE = 1 is a differential drive robot without contour
%      TYPE = 2 is a differential drive robot with round shape
%      TYPE = 3 is a round shaped robot with a line at theta
%      TYPE = 4 is a differential drive robot with rectangular shape
%      TYPE = 5 is a rectangular shaped robot with a line at theta
%
%   DRAWROBOT(X,COLOR,TYPE,W,L) draws a robot of type TYPE with
%   width W and length L in [m].
%
%   H = DRAWROBOT(...) returns a column vector of handles to all
%   graphic objects of the robot drawing. Remember that not all
%   graphic properties apply to all types of graphic objects. Use
%   FINDOBJ to find and access the individual objects.
%
%   See also DRAWRECT, DRAWARROW, FINDOBJ, PLOT.

% v.1.0, 16.06.03, Kai Arras, ASL-EPFL
% v.1.1, 12.10.03, Kai Arras, ASL-EPFL: uses drawrect
% v.1.2, 03.12.03, Kai Arras, CAS-KTH : types implemented


function h = drawrobot(varargin);

% Constants
DEFT = 2;            % default robot type
DEFB = 0.4;          % default robot width in [m], defines y-dir. of {R}
WT   = 0.03;         % wheel thickness in [m]
DEFL = DEFB+0.2;     % default robot length in [m]
WD   = 0.2;          % wheel diameter in [m]
RR   = WT/2;         % wheel roundness radius in [m]
RRR  = 0.04;         % roundness radius for rectangular robots in [m]
HL   = 0.09;         % arrow head length in [m]
CS   = 0.1;          % cross size in [m], showing the {R} origin

% Input argument check
inputerr = 0;
switch nargin,
  case 2,
    xvec  = varargin{1};
    color = varargin{2};
    type  = DEFT;
    B     = DEFB;
    L     = DEFL;
  case 3;
    xvec  = varargin{1};
    color = varargin{2};
    type  = varargin{3};
    B     = DEFB;
    L     = DEFL;
  case 5;
    xvec  = varargin{1};
    color = varargin{2};
    type  = varargin{3};
    B     = varargin{4};
    L     = varargin{5};
  otherwise
    inputerr = 1;
end;

% Main switch statement
if ~inputerr,
  x = xvec(1); y = xvec(2); theta = xvec(3);
  T = [x; y];
  R = [cos(theta), -sin(theta); sin(theta), cos(theta)];
  
  switch type
    case 0,
      % Draw origin cross
      p = R*[CS, -CS, 0, 0; 0, 0, -CS, CS] + T*ones(1,4);   % horiz. line
      h = plot(p(1,1:2),p(2,1:2),'Color',color,p(1,3:4),p(2,3:4),'Color',color);
      
    case 1,
      % Draw wheel pair with axis and arrow
      xlw = [x+B/2*cos(theta+pi/2); y+B/2*sin(theta+pi/2); theta];
      h1 = drawrect(xlw,WD,WT,RR,1,color);  % left wheel
      xlw = [x-B/2*cos(theta+pi/2); y-B/2*sin(theta+pi/2); theta];
      h2 = drawrect(xlw,WD,WT,RR,1,color);  % right wheel
      % Draw axis cross with arrow
      p = R*[0, 0; -B/2+WT/2, B/2-WT/2] + T*ones(1,2);
      h3 = plot(p(1,:),p(2,:),'Color',color);
      p = R*[L/2; 0] + T;
      h4 = drawarrow(T,p,1,HL,color);
      h = cat(1,h1,h2,h3,h4);
      
    case 2,
      % Draw wheel pair with axis and arrow
      xlw = [x+B/2*cos(theta+pi/2); y+B/2*sin(theta+pi/2); theta];
      h1 = drawrect(xlw,WD,WT,RR,1,color);  % left wheel
      xlw = [x-B/2*cos(theta+pi/2); y-B/2*sin(theta+pi/2); theta];
      h2 = drawrect(xlw,WD,WT,RR,1,color);  % right wheel
      % Draw axis cross with arrow
      p = R*[0, 0; -B/2+WT/2, B/2-WT/2] + T*ones(1,2);
      h3 = plot(p(1,:),p(2,:),'Color',color);
      p = R*[(B+WT)/2; 0] + T;
      h4 = drawarrow(T,p,1,HL,color);
      % Draw circular contour
      radius = (B+WT)/2;
      h5 = drawellipse(xvec,radius,radius,color);
      h = cat(1,h1,h2,h3,h4,h5);
      
    case 3,
      % Draw circular contour
      radius = (B+WT)/2;
      h1 = drawellipse(xvec,radius,radius,color);
      % Draw line with orientation theta with length radius
      p = R*[(B+WT)/2;0] + T;
      h2 = plot([T(1) p(1)],[T(2) p(2)],'Color',color,'linewidth',2);
      h = cat(1,h1,h2);
      
    case 4,
      % Draw wheel pair with axis and arrow
      xlw = [x+B/2*cos(theta+pi/2); y+B/2*sin(theta+pi/2); theta];
      h1 = drawrect(xlw,WD,WT,RR,1,color);  % left wheel
      xlw = [x-B/2*cos(theta+pi/2); y-B/2*sin(theta+pi/2); theta];
      h2 = drawrect(xlw,WD,WT,RR,1,color);  % right wheel
      % Draw axis cross with arrow
      p = R*[0, 0; -B/2+WT/2, B/2-WT/2] + T*ones(1,2);
      h3 = plot(p(1,:),p(2,:),'Color',color);
      p = R*[L/2; 0] + T;
      h4 = drawarrow(T,p,1,HL,color);
      % Draw rectangular contour
      h5 = drawrect(xvec,L,B,RRR,0,color);
      h = cat(1,h1,h2,h3,h4,h5);
      
    case 5,
      % Draw rectangular contour
      h1 = drawrect(xvec,L,B,RRR,0,color);
      % Draw line with orientation theta with length L
      p = R*[L/2; 0] + T;
      h2 = plot([T(1) p(1)],[T(2) p(2)],'Color',color,'linewidth',2);
      h = cat(1,h1,h2);
      
    otherwise
      disp('drawrobot: Unsupported robot type'); h = [];
  end;
else
  disp('drawrobot: Wrong number of input arguments'); h = [];
end;
