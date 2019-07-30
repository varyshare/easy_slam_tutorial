%DRAWELLIPSE Draw ellipse.
%   DRAWELLIPSE(X,A,B,COLOR) draws an ellipse at X = [x y theta]
%   with half axes A and B. Theta is the inclination angle of A,
%   regardless if A is smaller or greater than B. COLOR is a
%   [r g b]-vector or a color string such as 'r' or 'g'.
%
%   H = DRAWELLIPSE(...) returns the graphic handle H.
%
%   See also DRAWPROBELLIPSE.

% v.1.0-v.1.1, Aug.97-Jan.03, Kai Arras, ASL-EPFL
% v.1.2, 03.12.03, Kai Arras, CAS-KTH: (x,a,b) interface 


function h = drawellipse(x,a,b,color);

% Constants
NPOINTS = 100;                   % point density or resolution

% Compose point vector
ivec = 0:2*pi/NPOINTS:2*pi;     % index vector
p(1,:) = a*cos(ivec);           % 2 x n matrix which
p(2,:) = b*sin(ivec);           % hold ellipse points

% Translate and rotate
xo = x(1); yo = x(2); angle = x(3);
R  = [cos(angle) -sin(angle); sin(angle) cos(angle)];
T  = [xo; yo]*ones(1,length(ivec));
p = R*p + T;

% Plot
h = plot(p(1,:),p(2,:),'Color',color, 'linewidth', 2);
