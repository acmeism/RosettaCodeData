import fileinput
import sys

nodata = 0;             # Current run of consecutive flags<0 in lines of file
nodata_max=-1;          # Max consecutive flags<0 in lines of file
nodata_maxline=[];      # ... and line number(s) where it occurs

tot_file = 0            # Sum of file data
num_file = 0            # Number of file data items with flag>0

infiles = sys.argv[1:]

for line in fileinput.input():
  tot_line=0;             # sum of line data
  num_line=0;             # number of line data items with flag>0

  # extract field info
  field = line.split()
  date  = field[0]
  data  = [float(f) for f in field[1::2]]
  flags = [int(f)   for f in field[2::2]]

  for datum, flag in zip(data, flags):
    if flag<1:
      nodata += 1
    else:
      # check run of data-absent fields
      if nodata_max==nodata and nodata>0:
        nodata_maxline.append(date)
      if nodata_max<nodata and nodata>0:
        nodata_max=nodata
        nodata_maxline=[date]
      # re-initialise run of nodata counter
      nodata=0;
      # gather values for averaging
      tot_line += datum
      num_line += 1

  # totals for the file so far
  tot_file += tot_line
  num_file += num_line

  print "Line: %11s  Reject: %2i  Accept: %2i  Line_tot: %10.3f  Line_avg: %10.3f" % (
        date,
        len(data) -num_line,
        num_line, tot_line,
        tot_line/num_line if (num_line>0) else 0)

print ""
print "File(s)  = %s" % (", ".join(infiles),)
print "Total    = %10.3f" % (tot_file,)
print "Readings = %6i" % (num_file,)
print "Average  = %10.3f" % (tot_file / num_file,)

print "\nMaximum run(s) of %i consecutive false readings ends at line starting with date(s): %s" % (
    nodata_max, ", ".join(nodata_maxline))
