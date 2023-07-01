# syntax: GAWK -f UPC.AWK
BEGIN {
    ls_arr["   ## #"] = 0
    ls_arr["  ##  #"] = 1
    ls_arr["  #  ##"] = 2
    ls_arr[" #### #"] = 3
    ls_arr[" #   ##"] = 4
    ls_arr[" ##   #"] = 5
    ls_arr[" # ####"] = 6
    ls_arr[" ### ##"] = 7
    ls_arr[" ## ###"] = 8
    ls_arr["   # ##"] = 9
    for (i in ls_arr) {
      tmp = i
      gsub(/#/,"x",tmp)
      gsub(/ /,"#",tmp)
      gsub(/x/," ",tmp)
      rs_arr[tmp] = ls_arr[i]
    }
    split("3,1,3,1,3,1,3,1,3,1,3,1",weight_arr,",")
    bc_arr[++n] = "         # #   # ##  #  ## #   ## ### ## ### ## #### # # # ## ##  #   #  ##  ## ###  # ##  ## ### #  # #       "
    bc_arr[++n] = "        # # #   ##   ## # #### #   # ## #   ## #   ## # # # ###  # ###  ##  ## ###  # #  ### ###  # # #         "
    bc_arr[++n] = "         # #    # # #  ###  #   #    # #  #   #    # # # # ## #   ## #   ## #   ##   # # #### ### ## # #         "
    bc_arr[++n] = "       # # ##  ## ##  ##   #  #   #  # ###  # ##  ## # # #   ## ##  #  ### ## ## #   # #### ## #   # #        "
    bc_arr[++n] = "         # # ### ## #   ## ## ###  ##  # ##   #   # ## # # ### #  ## ##  #    # ### #  ## ##  #      # #          "
    bc_arr[++n] = "          # #  #   # ##  ##  #   #   #  # ##  ##  #   # # # # #### #  ##  # #### #### # #  ##  # #### # #         "
    bc_arr[++n] = "         # #  #  ##  ##  # #   ## ##   # ### ## ##   # # # #  #   #   #  #  ### # #    ###  # #  #   # #        "
    bc_arr[++n] = "        # # #    # ##  ##   #  # ##  ##  ### #   #  # # # ### ## ## ### ## ### ### ## #  ##  ### ## # #         "
    bc_arr[++n] = "         # # ### ##   ## # # #### #   ## # #### # #### # # #   #  # ###  #    # ###  # #    # ###  # # #       "
    bc_arr[++n] = "        # # # #### ##   # #### # #   ## ## ### #### # # # #  ### # ###  ###  # # ###  #    # #  ### # #         "
    bc_arr[++n] = "        # # # #### ##   # #### # #   ## ## ### #### # # # #  ### # ###  ###  # # ###  #    # #  ### #" # NG
    tmp = "123456712345671234567123456712345671234567"
    printf("%2s: %-18s---%s-----%s---\n","N","UPC-A",tmp,tmp) # heading
    for (i=1; i<=n; i++) {
#     accept any number of spaces at beginning or end; I.E. minimum of 9 is not enforced
      sub(/^ +/,"",bc_arr[i])
      sub(/ +$/,"",bc_arr[i])
      bc = bc_arr[i]
      if (length(bc) == 95 && substr(bc,1,3) == "# #" && substr(bc,46,5) == " # # " && substr(bc,93,3) == "# #") {
        upc = ""
        sum = upc_build(ls_arr,1,substr(bc,4,42))
        sum += upc_build(rs_arr,7,substr(bc,51,42))
        if (upc ~ /^x+$/) { msg = "reversed" }
        else if (upc ~ /x/) { msg = "invalid digit(s)" }
        else if (sum % 10 != 0) { msg = "bad check digit" }
        else { msg = upc }
      }
      else {
        msg = "invalid format"
      }
      printf("%2d: %-18s%s\n",i,msg,bc)
    }
    exit(0)
}
function upc_build(arr,pos,bc,  i,s,sum) {
    pos--
    for (i=1; i<=42; i+=7) {
      s = substr(bc,i,7)
      pos++
      if (s in arr) {
        upc = upc arr[s]
        sum += arr[s] * weight_arr[pos]
      }
      else {
        upc = upc "x"
      }
    }
    return(sum)
}
