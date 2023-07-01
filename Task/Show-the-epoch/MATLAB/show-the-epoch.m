d = [0,1,2,3.5,-3.5,1000*365,1000*366,now+[-1,0,1]];
for k=1:length(d)
    printf('day %f\t%s\n',d(k),datestr(d(k),0))
    disp(datevec(d(k)))
end;
