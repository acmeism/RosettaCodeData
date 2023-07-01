# syntax: GAWK -f MERGE_AND_AGGREGATE_DATASETS.AWK RC-PATIENTS.CSV RC-VISITS.CSV
# files may appear in any order
#
# sorting:
#   PROCINFO["sorted_in"] is used by GAWK
#   SORTTYPE is used by Thompson Automation's TAWK
#
{ # printf("%s %s\n",FILENAME,$0) # print input
    split($0,arr,",")
    if (FNR == 1) {
      file = (arr[2] == "LASTNAME") ? "patients" : "visits"
      next
    }
    patient_id_arr[key] = key = arr[1]
    if (file == "patients") {
      lastname_arr[key] = arr[2]
    }
    else if (file == "visits") {
      if (arr[2] > visit_date_arr[key]) {
        visit_date_arr[key] = arr[2]
      }
      if (arr[3] != "") {
        score_arr[key] += arr[3]
        score_count_arr[key]++
      }
    }
}
END {
    print("")
    PROCINFO["sorted_in"] = "@ind_str_asc" ; SORTTYPE = 1
    fmt = "%-10s %-10s %-10s %9s %9s %6s\n"
    printf(fmt,"patient_id","lastname","last_visit","score_sum","score_avg","scores")
    for (i in patient_id_arr) {
      avg = (score_count_arr[i] > 0) ? score_arr[i] / score_count_arr[i] : ""
      printf(fmt,patient_id_arr[i],lastname_arr[i],visit_date_arr[i],score_arr[i],avg,score_count_arr[i]+0)
    }
    exit(0)
}
