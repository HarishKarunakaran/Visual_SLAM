function [range, bearing] = findRangeBearing(image, point, mean)
    RWC = findWC(image, point);
    range = sqrt((RWC(1) - mean(1))^2 + (RWC(2) - mean(2))^2);
    bearing = atan2((RWC(2) - mean(2)), (RWC(1) - mean(1))) - mean(3);
%     elevation = atan2((RWC(3) - mean(3)), (sqrt((RWC(1) - mean(1))^2 + (RWC(2) - mean(2))^2)));
end