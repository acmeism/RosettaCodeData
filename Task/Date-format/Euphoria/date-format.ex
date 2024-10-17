constant days = {"Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"}
constant months = {"January","February","March","April","May","June",
    "July","August","September","October","November","December"}

sequence now

now = date()
now[1] += 1900

printf(1,"%d-%02d-%02d\n",now[1..3])
printf(1,"%s, %s %d, %d\n",{days[now[7]],months[now[2]],now[3],now[1]})
