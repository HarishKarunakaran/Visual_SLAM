function [mean, variance] = prediction_step(mean, variance)
    total = size(mean,1);
    dt = 1;
    Fx = eye(total);
    d = [dt,dt,dt];
    Fx(1:3,4:6) = diag(d);
    mean = Fx*mean;
    G = Fx;
    motionNoise = 0.1;
    R3 = [motionNoise, 0, 0;
          0, motionNoise, 0; 
         0, 0, motionNoise/10];
    R = zeros(size(variance,1));
    R(1:3,1:3) = R3;
    R(4:6,4:6) = R3;
    variance=G*variance*G'+R;
end
