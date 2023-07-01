longmonth = [1 3 5 7 8 10 12];

i = 1;

for y = 1900:2100
    for m = 1:numel(longmonth)
        [num,name] = weekday(datenum(y,longmonth(m),1));
        if num == 6
            x(i,:) = datestr(datenum(y,longmonth(m),1),'mmm yyyy'); %#ok<SAGROW>
            i = i+1;
        end
    end
end

fprintf('There are %i months with 5 weekends between 1900 and 2100.\n',length(x))

fprintf('\n The first 5 months are:\n')
for j = 1:5
    fprintf('\t %s \n',x(j,:))
end

fprintf('\n The final 5 months are:\n')
for j = length(x)-4:length(x)
    fprintf('\t %s \n',x(j,:))
end
