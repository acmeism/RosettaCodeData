#!/usr/bin/env -S gawk -f

BEGIN {
  ENDINGS["āre"]=1
  ENDINGS["are"]=1
  ENDINGS["ēre"]=2
  ENDINGS["ere"]=3
  ENDINGS["īre"]=4
  ENDINGS["ire"]=4

  first_person_singular=1
  RULE[first_person_singular][1]="ō"
  RULE[first_person_singular][2]="eō"
  RULE[first_person_singular][3]="ō"
  RULE[first_person_singular][4]="iō"

  second_person_singular=2
  RULE[second_person_singular][1]="ās"
  RULE[second_person_singular][2]="ēs"
  RULE[second_person_singular][3]="is"
  RULE[second_person_singular][4]="īs"

  third_person_singular=3
  RULE[third_person_singular][1]="at"
  RULE[third_person_singular][2]="et"
  RULE[third_person_singular][3]="it"
  RULE[third_person_singular][4]="it"

  first_person_plural=4
  RULE[first_person_plural][1]="āmus"
  RULE[first_person_plural][2]="ēmus"
  RULE[first_person_plural][3]="imus"
  RULE[first_person_plural][4]="īmus"

  second_person_plural=5
  RULE[second_person_plural][1]="ātis"
  RULE[second_person_plural][2]="ētis"
  RULE[second_person_plural][3]="itis"
  RULE[second_person_plural][4]="ītis"

  third_person_plural=6
  RULE[third_person_plural][1]="ant"
  RULE[third_person_plural][2]="ent"
  RULE[third_person_plural][3]="unt"
  RULE[third_person_plural][4]="iunt"

  print \
"infinitive│            ╭─person─╮                      ╭─person─╮        \n"\
"          │╭─────────── singular ──────────╮╭──────────  plural  ────────────╮\n"\
"          ││ 1st        2nd        3rd     ││ 1st        2nd        3rd      │"

}

NF==0 || $1=="#" || index($1,"#")==1 {next}

1 {
  printf "%-12s", $1
  stem=substr($1,1,length($1)-3)
  if (stem=="") { printf "%s\n", "* Can not conjugate"; next }
  endn=substr($1,length($1)-2)
  if (endn in ENDINGS) {
    kind=ENDINGS[endn]
    printf "%-11s", stem RULE[first_person_singular][kind]
    printf "%-11s", stem RULE[second_person_singular][kind]
    printf "%-11s", stem RULE[third_person_singular][kind]
    printf "%-11s", stem RULE[first_person_plural][kind]
    printf "%-11s", stem RULE[second_person_plural][kind]
    printf "%-11s", stem RULE[third_person_plural][kind]
  }
  else {
    printf "%s", "* Can not conjugate"
  }
  printf "\n"
  next
  }
