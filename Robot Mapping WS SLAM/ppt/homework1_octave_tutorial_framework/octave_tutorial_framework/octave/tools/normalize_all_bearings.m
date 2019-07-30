function [zNorm] = normalize_all_bearings(z)
%Go over the observations vector and normalize the bearings

for(i=2:3:length(z))
   z(i) = normalize_angle(z(i));
endfor
zNorm = z;
