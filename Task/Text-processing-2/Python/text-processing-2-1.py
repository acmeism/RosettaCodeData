import re
import zipfile
import StringIO

def munge2(readings):

   datePat = re.compile(r'\d{4}-\d{2}-\d{2}')
   valuPat = re.compile(r'[-+]?\d+\.\d+')
   statPat = re.compile(r'-?\d+')
   allOk, totalLines = 0, 0
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
         print 'Bad formatting', line
         continue
		
      if len(pairs)!=24 or any( int(p[1]) < 1 for p in pairs ):
         print 'Missing values', line
         continue

      if date in datestamps:
         print 'Duplicate datestamp', line
         continue
      datestamps.add(date)
      allOk += 1

   print 'Lines with all readings: ', allOk
   print 'Total records: ', totalLines

#zfs = zipfile.ZipFile('readings.zip','r')
#readings = StringIO.StringIO(zfs.read('readings.txt'))
readings = open('readings.txt','r')
munge2(readings)
