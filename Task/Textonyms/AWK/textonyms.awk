#!/usr/bin/env -S gawk -E

BEGIN { # user's configuration area

  KEYMAP="2 abc 3 def 4 ghi 5 jkl 6 mno 7 pqrs 8 tuv 9 wxyz"
  FNAME="/usr/share/dict/american-english"     # 0.5 MB; 102775 words;

  #KEYMAP="2 αβγά 3 δεζέ 4 ηθιήίϊΐ 5 κλμ 6 νξοό 7 πρσς 8 τυφύϋΰ 9 χψωώ"
  #FNAME="/usr/share/dict/greek"               # 19.5MB; 828808 words;

              #   where generated data will be written,
              # or comment out a line if you don’t need it.
  EXPORT_TXN="/tmp/textonyms"
  EXPORT_ALL="/tmp/phonewords"
  EXPORT_BAD="/tmp/invalidwords"   #also the line ‘BUFF_ERRW = BUFF_...’
}
BEGIN { # main
  delete ARGV; ARGC=1   # do not accept command line arguments
  delete XEK            # reserve id for use only as a hash table
  delete TXN            # reserve id ...
  AZ=""                 # generated Alphabet
  EE=0                  # invalid word Counter
  KK=0                  # valid word Counter
  TT=0                  # textonym groups in the table TXN
  BUFF_ERRW=""          # invalid word buffer
  TOTAL=1               # enum
  COUNT=2               # enum

  STDERR="/dev/stderr"
  OLD_RS=RS
  OLD_FS=FS
  processFile()
  generateReport()
  userQuery()
}
function processFile(    ii,jj,nn,errW,ss,aKey,aGroup,qqq){
  $0=KEYMAP
  AZ=" "
  for (ii=1; ii<=NF; ii=ii+2) {
    aKey=$ii; aGroup=$(ii+1)
    nn=split(aGroup, qqq, //)
    for (jj=1; jj<=nn; jj++) {ss=qqq[jj]; XEK[ss]=aKey; AZ = AZ ss " " }
  }
  AZ = AZ " "
  ######################
       RS="^$"         #
       FS="[\n\t ]+"   #
  ######################
  if ((getline <FNAME) <= 0) {
    printf "unexpected EOF or error: ‘%s’ %s\n",FNAME,ERRNO   >STDERR
    exit 1
  } else printf "total words in the file ‘%s’: %s\n", FNAME,NF

  for (ii=1; ii<=NF; ii++) {
    errW=0
    ss=tolower($ii)
    nn=split(ss, qqq, //)
    nmb=""
    for (jj=1; jj<=nn; jj++) {
      lchr=qqq[jj]
      if (index(AZ," "lchr" ")>0) { nmb = nmb XEK[lchr] }
      else {
        EE++
        errW=1
        BUFF_ERRW = BUFF_ERRW $ii "\n"
        break
      }
    }
    if (errW) { continue }
    T9=TXN[nmb][TOTAL]
    if (index(T9" "," "ss" ")==0) {
      TXN[nmb][TOTAL] = T9 " " ss
      TXN[nmb][COUNT]++
    }
    KK++
  }
}
function generateReport(        elm){
  for (elm in TXN) { if (TXN[elm][COUNT]>1) { TT++ } }
  printf "valid words:                   %9s\n", KK
  printf "invalid words:                 %9s\n", EE
  printf "table indices for valid words: %9s\n", length(TXN)
  printf "textonym groups in the table:  %9s\n", TT
  exportData()
  close(EXPORT_BAD); close(EXPORT_TXN); close(EXPORT_ALL)
}
function exportData(        elm){
  if (EXPORT_BAD != "") print BUFF_ERRW  >EXPORT_BAD

  if (EXPORT_TXN != "" && EXPORT_ALL != "") {
    printf "%s\n",
       "number-of-textonyms\tword's-length\tkeys\tlist-of-textonyms" >EXPORT_ALL
    printf "%s\n",
       "number-of-textonyms\tword's-length\tkeys\tlist-of-textonyms" >EXPORT_TXN
    for (elm in TXN) {
      printf "%s\t%s\t%s\t%s\n",
                 TXN[elm][COUNT], length(elm), elm, TXN[elm][TOTAL]  >EXPORT_ALL
      if (TXN[elm][COUNT]>1) {
        printf "%s\t%s\t%s\t%s\n",
                 TXN[elm][COUNT], length(elm), elm, TXN[elm][TOTAL]  >EXPORT_TXN
      }
    }
    return ## return ## return ## return ##
  } else if (EXPORT_ALL != "") {
      printf "%s\n",
       "number-of-textonyms\tword's-length\tkeys\tlist-of-textonyms" >EXPORT_ALL
      for (elm in TXN) {
        printf "%s\t%s\t%s\t%s\n",
               TXN[elm][COUNT], length(elm), elm, TXN[elm][TOTAL]    >EXPORT_ALL
      }
  }
  else if (EXPORT_TXN != "") {
    printf "%s\n",
       "number-of-textonyms\tword's-length\tkeys\tlist-of-textonyms" >EXPORT_TXN
    for (elm in TXN) {
      if (TXN[elm][COUNT]>1) {
        printf "%s\t%s\t%s\t%s\n",
                 TXN[elm][COUNT], length(elm), elm, TXN[elm][TOTAL]  >EXPORT_TXN
      }
    }
  }
}
function userQuery(        userasks,ss,ss1,nn,key,words){
  printf "txn>> "
  RS=OLD_RS
  FS=OLD_FS
  while ((getline ) > 0) {
    userasks=$1
    if (NF==0){  printf "txn>> ", "";  continue }
    else if (userasks ~ /^-e|--ex|--exit$/) { exit }
    else if (userasks ~ /^[0-9]+$/) {
      nn=TXN[userasks][COUNT]+0
      words=TXN[userasks][TOTAL]
      if (nn == 0) { printf "%s -> %s\n", userasks,"no matching words" }
      else {         printf "%s -> (%s) %s\n", userasks,nn,words }
    }
    else {
      ss=tolower(userasks)
      if ((key=keySeq_orElse_zero(ss))>0) {
         ss1=(index((TXN[key][TOTAL]" ") , " "ss" ")>0) ?
            ", and the word is in" : ", but the word is not in"
         printf "%s -> %s; the key is%s in the table%s\n", ss,key,
               ((key in TXN) ?"":" not"),ss1
      }
      else {
        printf "%s -> not a valid word for the alphabet:\n%s\n", userasks,AZ
      }
    }
    printf "txn>> "
  }
  printf "\n"
}
function keySeq_orElse_zero(aWord,        qqq,lchr,nn,jj,buf){
  nn=split(aWord, qqq, //)
  for (jj=1; jj<=nn; jj++) {
    lchr=qqq[jj]
    if (index(AZ," "lchr" ")>0) { buf = buf XEK[lchr] } else { return 0 }
  }
  return buf
}
