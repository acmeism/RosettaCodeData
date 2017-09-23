# Input: { "max":         max_run_length,
#          "starts":      array_of_start_line_values, # of all the maximal runs
#          "start_dates": array_of_start_dates        # of all the maximal runs
#        }
def report:
  (.starts | length) as $l
  | if $l == 1 then
      "There is one maximal run of lines with flag<=0.",
      "The maximal run has length \(.max) and starts at line \(.starts[0]) and has start date \(.start_dates[0])."
    elif $l == 0 then
      "There is no lines with flag<=0."
    else
      "There are \($l) maximal runs of lines with flag<=0.",
      "These runs have length \(.max) and start at the following line numbers:",
      "\(.starts)",
      "The corresponding dates are:",
      "\(.start_dates)"
    end;

# "process" processes "tab-separated string values" on stdin
def process:

  # Given a line in the form of an array [date, datum1, flag2, ...],
  # "synopsis" returns [ number of data items on the line with flag>0, sum, number of data items on the line with flag<=0 ]
  def synopsis: # of a line
    . as $row
    | reduce range(0; (length - 1) / 2) as $i
        ( [0,0,0];
          ($row[1+ (2*$i)] | tonumber) as $datum
          | ($row[2+(2*$i)] | tonumber) as $flag
         | if ($flag>0) then .[0] += 1 | .[1] += $datum else .[2] += 1 end );

  # state: {"line":       line_number # (first line is line 0)
  #         "synopis":    _,      # value returned by "synopsis"
  #         "start":      line_number_of_start_of_current_run,
  #         "start_date": date_of_start_of_current_run,
  #         "length":     length_of_current_run # so far
  #         "max":        max_run_length        # so far
  #         "starts":     array_of_start_values # of all the maximal runs
  #         "start_dates": array_of_start_dates # of all the maximal runs
  #         }
  foreach ((inputs | split("\t")), null) as $line  # null signals END
      # Slots are effectively initialized by default to null
      ( { "line": -1, "length": 0, "max": 0, "starts": [], "start_dates": [] };
        if $line == null then .line = null
	else
	  .line += 1
	  # | debug
          # synopsis returns [number with flag>0, sum, number with flag<=0 ]
          | .synopsis = ($line | synopsis)
          | if .synopsis[2] > 0 then
	      if .start then . else .start = .line | .start_date = $line[0] end
	      | .length += 1
	      | if .max < .length then
	          (.max = .length)
		  | .starts = [ .start ]
		  | .start_dates = [ .start_date ]
	        elif .max == .length then
		  .starts += [ .start ]
		  | .start_dates += [ .start_date ]
	        else .
	        end
	    else .start = null | .length = 0
	    end
	 end;
	.)
  | if .line == null then {max, starts, start_dates} | report
    else .synopsis
    end;

process
