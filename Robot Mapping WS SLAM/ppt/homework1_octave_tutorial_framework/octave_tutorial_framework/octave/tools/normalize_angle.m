function [phiNorm] = normalize_angle(phi)
%Normalize phi to be between -pi and pi

while(phi>pi)
	phi = phi - 2*pi;
endwhile

while(phi<-pi)
	phi = phi + 2*pi;
endwhile
phiNorm = phi;

end
