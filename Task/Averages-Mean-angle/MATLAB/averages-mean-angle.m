function u = mean_angle(phi)
	u = angle(mean(exp(i*pi*phi/180)))*180/pi;
end
