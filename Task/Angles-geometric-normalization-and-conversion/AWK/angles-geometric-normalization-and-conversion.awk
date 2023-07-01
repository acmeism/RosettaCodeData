# syntax: GAWK -f ANGLES_(GEOMETRIC)_NORMALIZATION_AND_CONVERSION.AWK
# gawk starts showing discrepancies at test case number 7 when compared with C#
BEGIN {
    pi = atan2(0,-1)
    data_leng = split("-2,-1,0,1,2,6.2831853,16,57.2957795,359,399,6399,1000000",data_arr,",")
    unit_leng = split("degree,gradian,mil,radian",unit_arr,",")
    printf("%-10s %-10s %-8s %-12s %-12s %-12s %-12s test#\n","angle","normalized","unit","degrees","gradians","mils","radians")
    for (a=1; a<=data_leng; a++) {
      angle = data_arr[a]
      arr["degree"]  = normalize(angle,360)
      arr["gradian"] = normalize(angle,400)
      arr["mil"]     = normalize(angle,6400)
      arr["radian"]  = normalize(angle,pi*2)
      print("") # optional blank line between groupings
      for (b=1; b<=unit_leng; b++) {
        key1 = unit_arr[b]
        printf("%-10s %-10s %-8s",angle,arr[key1],unit_arr[b])
        for (c=1; c<=unit_leng; c++) {
          key2 = unit_arr[c]
          func_name = sprintf("%s2%s",key1,key2)
          printf(" %-12s",(key1 == key2) ? arr[key2] : @func_name(arr[key2]))
        }
        printf(" %d\n",a)
      }
    }
#   normalize_usage_stats()
    exit(0)
}
function normalize(angle,n,  a) {
    a = angle
    profile_arr[a][n]["+"] = 0
    profile_arr[a][n]["-"] = 0
    while (angle <= -n) { angle += n ; profile_arr[a][n]["+"]++ }
    while (angle >= n)  { angle -= n ; profile_arr[a][n]["-"]++ }
    return(angle)
}
function normalize_usage_stats(  a,b,c,n,total) {
    print("")
    PROCINFO["sorted_in"] = "@ind_num_asc"
    for (a in profile_arr) {
      for (b in profile_arr[a]) {
        for (c in profile_arr[a][b]) {
          n = profile_arr[a][b][c]
          if (n == 0) { continue }
          printf("%10s %10s %1s %7d\n",a,b,c,n)
          total += n
        }
      }
    }
    printf("%31d total\n",total)
}
function degree2gradian(angle) { return(angle * 10 / 9) }
function degree2mil(angle) { return(angle * 160 / 9) }
function degree2radian(angle) { return(angle * pi / 180) }
function gradian2degree(angle) { return(angle * 9 / 10) }
function gradian2mil(angle) { return(angle * 16) }
function gradian2radian(angle) { return(angle * pi / 200) }
function mil2degree(angle) { return(angle * 9 / 160) }
function mil2gradian(angle) { return(angle / 16) }
function mil2radian(angle) { return(angle * pi / 3200) }
function radian2degree(angle) { return(angle * 180 / pi) }
function radian2gradian(angle) { return(angle * 200 / pi) }
function radian2mil(angle) { return(angle * 3200 / pi) }
