BEGIN{
  nodata = 0;             # Current run of consecutive flags<0 in lines of file
  nodata_max=-1;          # Max consecutive flags<0 in lines of file
  nodata_maxline="!";     # ... and line number(s) where it occurs
}
FNR==1 {
  # Accumulate input file names
  if(infiles){
    infiles = infiles "," infiles
  } else {
    infiles = FILENAME
  }
}
{
  tot_line=0;             # sum of line data
  num_line=0;             # number of line data items with flag>0

  # extract field info, skipping initial date field
  for(field=2; field<=NF; field+=2){
    datum=$field;
    flag=$(field+1);
    if(flag<1){
      nodata++
    }else{
      # check run of data-absent fields
      if(nodata_max==nodata && (nodata>0)){
        nodata_maxline=nodata_maxline ", " $1
      }
      if(nodata_max<nodata && (nodata>0)){
        nodata_max=nodata
        nodata_maxline=$1
      }
      # re-initialise run of nodata counter
      nodata=0;
      # gather values for averaging
      tot_line+=datum
      num_line++;
    }
  }

  # totals for the file so far
  tot_file += tot_line
  num_file += num_line

  printf "Line: %11s  Reject: %2i  Accept: %2i  Line_tot: %10.3f  Line_avg: %10.3f\n", \
         $1, ((NF -1)/2) -num_line, num_line, tot_line, (num_line>0)? tot_line/num_line: 0

  # debug prints of original data plus some of the computed values
  #printf "%s  %15.3g  %4i\n", $0, tot_line, num_line
  #printf "%s\n  %15.3f  %4i  %4i  %4i  %s\n", $0, tot_line, num_line,  nodata, nodata_max, nodata_maxline


}

END{
  printf "\n"
  printf "File(s)  = %s\n", infiles
  printf "Total    = %10.3f\n", tot_file
  printf "Readings = %6i\n", num_file
  printf "Average  = %10.3f\n", tot_file / num_file

  printf "\nMaximum run(s) of %i consecutive false readings ends at line starting with date(s): %s\n", nodata_max, nodata_maxline
}
