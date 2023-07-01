use strict;
use warnings;

my $nodata = 0;               # Current run of consecutive flags<0 in lines of file
my $nodata_max = -1;          # Max consecutive flags<0 in lines of file
my $nodata_maxline = "!";     # ... and line number(s) where it occurs

my $infiles = join ", ", @ARGV;

my $tot_file = 0;
my $num_file = 0;

while (<>) {
  chomp;
  my $tot_line = 0;             # sum of line data
  my $num_line = 0;             # number of line data items with flag>0
  my $rejects  = 0;

  # extract field info, skipping initial date field
  my ($date, @fields) = split;
  while (@fields and my ($datum, $flag) = splice @fields, 0, 2) {
    if ($flag+1 < 2) {
      $nodata++;
      $rejects++;
      next;
    }

    # check run of data-absent fields
    if($nodata_max == $nodata and $nodata > 0){
      $nodata_maxline = "$nodata_maxline, $date";
    }
    if($nodata_max < $nodata and $nodata > 0){
      $nodata_max = $nodata;
      $nodata_maxline = $date;
    }
    # re-initialise run of nodata counter
    $nodata = 0;
    # gather values for averaging
    $tot_line += $datum;
    $num_line++;
  }

  # totals for the file so far
  $tot_file += $tot_line;
  $num_file += $num_line;

  printf "Line: %11s  Reject: %2i  Accept: %2i  Line_tot: %10.3f  Line_avg: %10.3f\n",
         $date, $rejects, $num_line, $tot_line, ($num_line>0)? $tot_line/$num_line: 0;

}

printf "\n";
printf "File(s)  = %s\n", $infiles;
printf "Total    = %10.3f\n", $tot_file;
printf "Readings = %6i\n", $num_file;
printf "Average  = %10.3f\n", $tot_file / $num_file;

printf "\nMaximum run(s) of %i consecutive false readings ends at line starting with date(s): %s\n",
       $nodata_max, $nodata_maxline;
