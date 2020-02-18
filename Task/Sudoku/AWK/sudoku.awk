# syntax: GAWK -f SUDOKU_RC.AWK
BEGIN {
#             row1      row2      row3      row4      row5      row6      row7      row8      row9
#   puzzle = "111111111 111111111 111111111 111111111 111111111 111111111 111111111 111111111 111111111" # NG duplicate hints
#   puzzle = "1........ ..274.... ...5....4 .3....... 75....... .....96.. .4...6... .......71 .....1.30" # NG can't use zero
#   puzzle = "1........ ..274.... ...5....4 .3....... 75....... .....96.. .4...6... .......71 .....1.39" # no solution
#   puzzle = "1........ ..274.... ...5....4 .3....... 75....... .....96.. .4...6... .......71 .....1.3." # OK
    puzzle = "123456789 456789123 789123456 ......... ......... ......... ......... ......... ........." # OK
    gsub(/ /,"",puzzle)
    if (length(puzzle) != 81) { error("length of puzzle is not 81") }
    if (puzzle !~ /^[1-9\.]+$/) { error("only 1-9 and . are valid") }
    if (gsub(/[1-9]/,"&",puzzle) < 17) { error("too few hints") }
    if (errors > 0) {
      exit(1)
    }
    plot(puzzle,"unsolved")
    if (dup_hints_check(puzzle) == 1) {
      if (solve(puzzle) == 1) {
        dup_hints_check(sos)
        plot(sos,"solved")
        printf("\nbef: %s\naft: %s\n",puzzle,sos)
        exit(0)
      }
      else {
        error("no solution")
      }
    }
    exit(1)
}
function dup_hints_check(ss,  esf,msg,Rarr,Carr,Barr,i,r_row,r_col,r_pos,r_hint,c_row,c_col,c_pos,c_hint,box) {
    esf = errors                       # errors so far
    for (i=0; i<81; i++) {
      # row
      r_row = int(i/9) + 1             # determine row: 1..9
      r_col = i%9 + 1                  # determine column: 1..9
      r_pos = i + 1                    # determine hint position: 1..81
      r_hint = substr(ss,r_pos,1)      # extract 1 character; the hint
      Rarr[r_row,r_hint]++             # save row
      # column
      c_row = i%9 + 1                  # determine row: 1..9
      c_col = int(i/9) + 1             # determine column: 1..9
      c_pos = (c_row-1) * 9 + c_col    # determine hint position: 1..81
      c_hint = substr(ss,c_pos,1)      # extract 1 character; the hint
      Carr[c_col,c_hint]++             # save column
      # box (there has to be a better way)
      if      ((r_row r_col) ~ /[123][123]/) { box = 1 }
      else if ((r_row r_col) ~ /[123][456]/) { box = 2 }
      else if ((r_row r_col) ~ /[123][789]/) { box = 3 }
      else if ((r_row r_col) ~ /[456][123]/) { box = 4 }
      else if ((r_row r_col) ~ /[456][456]/) { box = 5 }
      else if ((r_row r_col) ~ /[456][789]/) { box = 6 }
      else if ((r_row r_col) ~ /[789][123]/) { box = 7 }
      else if ((r_row r_col) ~ /[789][456]/) { box = 8 }
      else if ((r_row r_col) ~ /[789][789]/) { box = 9 }
      else { box = 0 }
      Barr[box,r_hint]++               # save box
    }
    dup_hints_print(Rarr,"row")
    dup_hints_print(Carr,"column")
    dup_hints_print(Barr,"box")
    return((errors == esf) ? 1 : 0)
}
function dup_hints_print(arr,rcb,  hint,i) {
# rcb - Row Column Box
    for (i=1; i<=9; i++) {             # "i" is either the row, column, or box
      for (hint=1; hint<=9; hint++) {  # 1..9 only; don't care about "." place holder
        if (arr[i,hint]+0 > 1) {       # was a digit specified more than once
          error(sprintf("duplicate hint in %s %d",rcb,i))
        }
      }
    }
}
function plot(ss,text1,text2,  a,b,c,d,ou) {
# 1st call prints the unsolved puzzle.
# 2nd call prints the solved puzzle
    printf("| - - - + - - - + - - - | %s\n",text1)
    for (a=0; a<3; a++) {
      for (b=0; b<3; b++) {
        ou = "|"
        for (c=0; c<3; c++) {
          for (d=0; d<3; d++) {
            ou = sprintf("%s %1s",ou,substr(ss,1+d+3*c+9*b+27*a,1))
          }
          ou = ou " |"
        }
        print(ou)
      }
      printf("| - - - + - - - + - - - | %s\n",(a==2)?text2:"")
    }
}
function solve(ss,  a,b,c,d,e,r,co,ro,bi,bl,nss) {
    i = 0
# first, use some simple logic to fill grid as much as possible
    do {
      i++
      didit = 0
      delete nr
      delete nc
      delete nb
      delete ca
      for (a=0; a<81; a++) {
        b = substr(ss,a+1,1)
        if (b == ".") {                # construct row, column and block at cell
          c = a % 9
          r = int(a/9)
          ro = substr(ss,r*9+1,9)
          co = ""
          for (d=0; d<9; d++) { co = co substr(ss,d*9+c+1,1) }
          bi = int(c/3)*3+(int(r/3)*3)*9+1
          bl = ""
          for (d=0; d<3; d++) { bl = bl substr(ss,bi+d*9,3) }
          e = 0
# count non-occurrences of digits 1-9 in combined row, column and block, per row, column and block, and flag cell/digit as candidate
          for (d=1; d<10; d++) {
            if (index(ro co bl, d) == 0) {
              e++
              nr[r,d]++
              nc[c,d]++
              nb[bi,d]++
              ca[c,r,d] = bi
            }
          }
          if (e == 0) {                # in case no candidate is available, give up
            return(0)
          }
        }
      }
# go through all cell/digit candidates
# hidden singles
      for (crd in ca) {
# a candidate may have been deleted after the loop started
        if (ca[crd] != "") {
          split(crd,spl,SUBSEP)
          c = spl[1]
          r = spl[2]
          d = spl[3]
          bi = ca[crd]
          a = c + r * 9
# unique solution if at least one non-occurrence counter is exactly 1
          if ((nr[r,d] == 1) || (nc[c,d] == 1) || (nb[bi,d] == 1)) {
            ss = substr(ss,1,a) d substr(ss,a+2,length(ss))
            didit = 1
# remove candidates from current row, column, block
            for (e=0; e<9; e++) {
              delete ca[c,e,d]
              delete ca[e,r,d]
            }
            for (e=0; e<3; e++) {
              for (b=0; b<3; b++) {
                delete ca[int(c/3)*3+b,int(r/3)*3+e,d]
              }
            }
          }
        }
      }
    } while (didit == 1)
# second, pick a viable solution for the next empty cell and see if it leads to a solution
    a = index(ss,".")-1
    if (a == -1) {                     # no more empty cells, done
      sos = ss
      return(1)
    }
    else {
      c = a % 9
      r = int(a/9)
# concatenate current row, column and block
# row
      co = substr(ss,r*9+1,9)
# column
      for (d=0; d<9; d++) { co = co substr(ss,d*9+c+1,1) }
# block
      c = int(c/3)*3+(int(r/3)*3)*9+1
      for (d=0; d<3; d++) { co = co substr(ss,c+d*9,3) }
      for (b=1; b<10; b++) {           # get a viable digit
        if (index(co,b) == 0) {        # check if candidate digit already exists
# is viable, put in cell
          nss = substr(ss,1,a) b substr(ss,a+2,length(ss))
          d = solve(nss)               # try to solve
          if (d == 1) {                # if successful, return
            return(1)
          }
        }
      }
    }
    return(0)                          # no digits viable, no solution
}
function error(message) { printf("error: %s\n",message) ; errors++ }
