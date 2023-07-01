/ List the dates of last Sundays of each month of
/ a given year
/ lastsundt.k

isleap: {(+/~x!' 4 100 400)!2}
wd: {(_jd x)!7}
dom: (31;28;31;30;31;30;31;31;30;31;30;31)
init: {:[isleap x;dom[1]::29;dom[1]::28]}
wdme: {[m;y]; init y; dt:(10000*y)+(100*m)+dom[m-1];jd::(_jd dt);mewd::(wd dt)}
lsd: {[m;y]; wdme[m;y];:[mewd>5;jd::jd+(6-mewd);jd::jd-(1+mewd)];dt:_dj(jd);yy:$(yr:dt%10000);dd:$(d:dt!100);mm:$(mo:((dt-yr*10000)%100));arr::arr,$(yy,"-",(2$mm),"-",(2$dd))}
lsd1: {[y];arr::(); m:1; do[12;lsd[m;y];m+:1]}
main: {[y]; lsd1[y];`0: ,"Dates of last Sundays of ",($y); 12 10#arr}
