$$ MODE TUSCRIPT
- epoch
number=1
dayofweeknr=DATE (date,day,month,year,number)
epoch=JOIN(year,"-",month,day)
PRINT "epoch: ", epoch," (daynumber ",number,")"
- today's daynumber
dayofweeknr=DATE (today,day,month,year,number)
date=JOIN (year,"-",month,day)
PRINT "today's date: ", date," (daynumber ", number,")"
