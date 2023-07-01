function t = mean_time_of_day(t)
    c = pi/(12*60*60);
    for k=1:length(t)
	a = sscanf(t{k},'%d:%d:%d');
	phi(k) = (a(1)*3600+a(2)*60+a(3));
    end;
    d = angle(mean(exp(i*phi*c)))/(2*pi); % days
    if (d<0) d += 1;
    t = datestr(d,"HH:MM:SS");
end;
