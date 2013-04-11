import re
import zipfile
import StringIO

def munge2(readings, debug=False):

   datePat = re.compile(r'\d{4}-\d{2}-\d{2}')
   valuPat = re.compile(r'[-+]?\d+\.\d+')
   statPat = re.compile(r'-?\d+')
   totalLines = 0
   dupdate, badform, badlen, badreading = set(), set(), set(), 0
   datestamps = set([])
   for line in readings:
      totalLines += 1
      fields = line.split('\t')
      date = fields[0]
      pairs = [(fields[i],fields[i+1]) for i in range(1,len(fields),2)]

      lineFormatOk = datePat.match(date) and \
         all( valuPat.match(p[0]) for p in pairs ) and \
         all( statPat.match(p[1]) for p in pairs )
      if not lineFormatOk:
         if debug: print 'Bad formatting', line
         badform.add(date)

      if len(pairs)!=24 or any( int(p[1]) < 1 for p in pairs ):
         if debug: print 'Missing values', line
      if len(pairs)!=24: badlen.add(date)
      if any( int(p[1]) < 1 for p in pairs ): badreading += 1

      if date in datestamps:
         if debug: print 'Duplicate datestamp', line
         dupdate.add(date)

      datestamps.add(date)

   print 'Duplicate dates:\n ', '\n  '.join(sorted(dupdate))
   print 'Bad format:\n ', '\n  '.join(sorted(badform))
   print 'Bad number of fields:\n ', '\n  '.join(sorted(badlen))
   print 'Records with good readings: %i = %5.2f%%\n' % (
      totalLines-badreading, (totalLines-badreading)/float(totalLines)*100 )
   print 'Total records: ', totalLines

readings = open('readings.txt','r')
munge2(readings)
