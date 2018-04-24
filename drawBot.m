function [xunit, yunit] = drawBot(x, y, z, r, orientation)
    th = orientation:1:orientation+360;
    th_radians = th*pi/180;
    xunit = r * cos(th_radians) + x;
    yunit = r * sin(th_radians) + y;
    z = repmat(z,1,length(xunit));
    plot3(xunit, yunit, z, 'r');
end 
