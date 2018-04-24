clear; clc; close all
% Take data only at each second
data = textread('slam1_groundtruth.txt');
timestamps = floor(data(:,1));
j = 1;
for i = 2:length(timestamps)
    if(timestamps(i-1) ~= timestamps(i))
        finalData(j,:) = data(i,:);
        j = j+1;
    end
end
finalData(29,:) = [];
x = finalData(:,2);
y = finalData(:,3);
z = finalData(:,4);
figure
az = 0;
el = 90;
plot(x,y,'k--')
view(az,el)
grid on
hold on
title('Ground Truth Trajectory')

%%
% Take data only at each second
data = textread('KeyFrameTrajectory.txt');
x_ORB = data(:,2);
y_ORB = data(:,3);
z_ORB = data(:,4);
az = 0;
el = 90;
figure
plot3(x_ORB,y_ORB,z_ORB,'r--')
set(gca, 'Ydir', 'reverse')
view(az,el)
grid on
title('ORB-SLAM2 Package Trajectory')