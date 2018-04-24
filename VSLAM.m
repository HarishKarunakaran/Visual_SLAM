clc; clear; close all;
mean = [-2.3174 -2.1669 -1.4569 0.1 0.1 0]';
sigma = [1 0 0 0 0 0; 0 1 0 0 0 0; 0 0 1 0 0 0; 0 0 0 1 0 0; 0 0 0 0 1 0; 0 0 0 0 0 1];
i = 1;
rgbFrame = rgb2gray(imread(sprintf('rgb%d.png',i)));
depthFrame = imread(sprintf('depth%d.png',i));
points1 = detectSURFFeatures(rgbFrame);
p1 = points1.selectStrongest(10);
[features1, valid_points1] = extractFeatures(rgbFrame, p1);
observedlandmarks(size(p1)) = false;
landmarkCount = 0;

for i = 1:size(features1,1)
    z(i).id = i;
    [range, bearing] = findRangeBearing(depthFrame, p1(i), mean);
    z(i).range = range;
    z(i).bearing = bearing;
    mean(6+2*i-1:6+2*i, 1) = findWC(depthFrame, p1(i));
    sigma(6+2*i-1:6+2*i, 6+2*i-1:6+2*i) = eye(2);
    landmarkCount = landmarkCount + 1;
end

%
for i = 1:155    
    [mean, sigma] = prediction_step(mean, sigma);
    rgbFrame = rgb2gray(imread(sprintf('rgb%d.png',i)));
    rgbFrame2 = rgb2gray(imread(sprintf('rgb%d.png',i+1)));
    depthFrame = imread(sprintf('depth%d.png',i+1));
    points1 = detectSURFFeatures(rgbFrame);
    points2 = detectSURFFeatures(rgbFrame2);
    p1 = points1.selectStrongest(10);
    p2 = points2.selectStrongest(10);
    [features1, valid_points1] = extractFeatures(rgbFrame, p1);
    [features2, valid_points2] = extractFeatures(rgbFrame2, p2);
    [indexPairs1, matchmetric]= matchFeatures(features1, features2);    
    for j = 1:size(indexPairs1,1)
        deleteIndex(j) = indexPairs1(j,1);
    end
    p1(deleteIndex) = []; %contains unmatched features
    for l = landmarkCount + 1:landmarkCount + 1 + size(p1)
        z(l).id = l;
        [range, bearing] = findRangeBearing(depthFrame, p1(l - landmarkCount), mean);    
        z(l).range = range;
        z(l).bearing = bearing;
        mean(6+2*l-1:6+2*l, 1) = findWC(depthFrame, p1(l - landmarkCount));
        sigma(6+2*l-1:6+2*l, 6+2*l-1:6+2*l) = eye(2);
        landmarkCount = landmarkCount + 1;
        observedlandmarks(l) = false;
    end
    
    [mean, sigma, observedlandmarks] = correction_step(mean, sigma, z, observedlandmarks);
    plot(mean(1), mean(2), 'r*');
    pause(0.01)
end
