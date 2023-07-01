import calendar
c=calendar.Calendar()
fridays={}
year=raw_input("year")
for item in c.yeardatescalendar(int(year)):
    for i1 in item:
        for i2 in i1:
            for i3 in i2:
                if "Fri" in i3.ctime() and year in i3.ctime():
                    month,day=str(i3).rsplit("-",1)
                    fridays[month]=day

for item in sorted((month+"-"+day for month,day in fridays.items()),
                   key=lambda x:int(x.split("-")[1])):
    print item
