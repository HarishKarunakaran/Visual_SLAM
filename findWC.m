function WC = findWC(image, point)

location = double(point.Location);
u = location(1);
v = location(2);
fx = 525.0;  % focal length x
fy = 525.0;  % focal length y
cx = 319.5;  % optical center x
cy = 239.5;  % optical center y

factor = 5000; % for the 16-bit PNG files

Z = double(image(ceil(v),ceil(u))) / factor;
X = (u - cx) * Z / fx;
Y = (v - cy) * Z / fy;

% WC = [X; Y; Z];
WC = [X;Y];
end