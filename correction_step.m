function [mu, sigma, observedLandmarks] = correction_step(mu, sigma, z, observedLandmarks)
m = size(z, 2);
Z = zeros(m*2, 1);
expectedZ = zeros(m*2, 1);
H = [];
Q = [];

for i = 1:m
	Hi=zeros(2,6);
	landmarkId = z(i).id;
	if(observedLandmarks(landmarkId)==false)
		mu(2*z(i).id+5:2*z(i).id+6)=mu(1:2)+z(i).range*[cos(z(i).bearing+mu(3));sin(z(i).bearing+mu(3))];
		observedLandmarks(landmarkId) = true;
    end
	Z(2*i-1:2*i)=[z(i).range;z(i).bearing];
	del=mu(2*z(i).id+5:2*z(i).id+6)- mu(1:2);
	expectedZ(2*i-1:2*i)=[(del'*del)^0.5;atan2(del(2),del(1))-mu(3)];
	ze=expectedZ(2*i-1:2*i);
	Hi(:,1:6)=(1/ze(1)^2)*[-ze(1)*del(1),-ze(1)*del(2),0,0,0,0;del(2),-del(1),-ze(1)^2,0,0,0];
	Hi(:,2*z(i).id+5:2*z(i).id+6)=(1/ze(1)^2)*[ze(1)*del(1),ze(1)*del(2);-del(2),del(1)];
    H = [H, zeros(2*(i-1),2)];
    H = [H; Hi];
	Q = [Q, zeros(size(Q,1),2);zeros(2,size(Q,1)),(-0.0031*z(i).range + 0.3671)^2*eye(2)];
end

K=sigma*H'*pinv(H*sigma*H'+Q);
mu=mu+K*(Z-expectedZ);
sigma=(eye(length(mu))-K*H)*sigma;

end