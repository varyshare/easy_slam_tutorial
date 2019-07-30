%DRAWPROBELLIPSE Draw elliptic probability region of a Gaussian in 2D.
%   DRAWPROBELLIPSE(X,C,ALPHA,COLOR) draws the elliptic iso-probabi-
%   lity contour of a Gaussian distributed bivariate random vector X
%   at the significance level ALPHA. The ellipse is centered at X =
%   [x; y] where C is the associated 2x2 covariance matrix. COLOR is
%   a [r g b]-vector or a color string such as 'r' or 'g'.
%
%   X and C can also be of size 3x1 and 3x3 respectively.
%
%   For proper scaling, the function CHI2INVTABLE is employed to
%   avoid the use of CHI2INV from the Matlab statistics toolbox.
%
%   In case of a negative definite matrix C, the ellipse collapses
%   to a line which is drawn instead.
%
%   H = DRAWPROBELLIPSE(...) returns the graphic handle H.
%
%   See also DRAWELLIPSE, CHI2INVTABLE, CHI2INV.

% v.1.0-v.1.3, 97-Jan.03, Kai Arras, ASL-EPFL
% v.1.4, 03.12.03, Kai Arras, CAS-KTH: toolbox version


function h = drawprobellipse(x,C,alpha,color);

% Calculate unscaled half axes
sxx = C(1,1); syy = C(2,2); sxy = C(1,2);
a = sqrt(0.5*(sxx+syy+sqrt((sxx-syy)^2+4*sxy^2)));   % always greater
b = sqrt(0.5*(sxx+syy-sqrt((sxx-syy)^2+4*sxy^2)));   % always smaller

% Remove imaginary parts in case of neg. definite C
if ~isreal(a), a = real(a); end;
if ~isreal(b), b = real(b); end;

% Scaling in order to reflect specified probability
a = a*sqrt(chi2invtable(alpha,2));
b = b*sqrt(chi2invtable(alpha,2));

% Look where the greater half axis belongs to
if sxx < syy, swap = a; a = b; b = swap; end;

% Calculate inclination (numerically stable)
if sxx ~= syy,
  angle = 0.5*atan(2*sxy/(sxx-syy));	
elseif sxy == 0,
  angle = 0;     % angle doesn't matter 
elseif sxy > 0,
  angle =  pi/4;
elseif sxy < 0,
  angle = -pi/4;
end;
x(3) = angle;

% Draw ellipse
h = drawellipse(x,a,b,color);