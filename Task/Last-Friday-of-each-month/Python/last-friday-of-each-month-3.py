import calendar
c=calendar.Calendar()
fridays={}
year=raw_input("year")
add=list.__add__
for day in reduce(add,reduce(add,reduce(add,c.yeardatescalendar(int(year))))):

    if "Fri" in day.ctime() and year in day.ctime():
        month,day=str(day).rsplit("-",1)
        fridays[month]=day

for item in sorted((month+"-"+day for month,day in fridays.items()),
                   key=lambda x:int(x.split("-")[1])):
    print item
