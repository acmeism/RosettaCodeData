def top_rank_per_department(n):
  group_by(.Department)
  | reduce .[] as $dept
     ([]; ($dept
           | map(.Salary)
           | sort            # from least to most
           | .[length - n:]  # top n salaries
           | reverse) as $max
         | ($dept[0] | .Department) as $dept
         | . + [ { "Department": $dept, "top_salaries": $max } ] );
