def table:
    "add 1  alter 3  backup 2  bottom 1  Cappend 2  change 1  Schange  Cinsert 2  Clast 3 " +
    "compress 4 copy 2 count 3 Coverlay 3 cursor 3  delete 3 Cdelete 2  down 1  duplicate " +
    "3 xEdit 1 expand 3 extract 3  find 1 Nfind 2 Nfindup 6 NfUP 3 Cfind 2 findUP 3 fUP 2 " +
    "forward 2  get  help 1 hexType 4  input 1 powerInput 3  join 1 split 2 spltJOIN load " +
    "locate 1 Clocate 2 lowerCase 3 upperCase 3 Lprefix 2  macro  merge 2 modify 3 move 2 " +
    "msg  next 1 overlay 1 parse preserve 4 purge 3 put putD query 1 quit  read recover 3 " +
    "refresh renum 3 repeat 3 replace 1 Creplace 2 reset 3 restore 4 rgtLEFT right 2 left " +
    "2  save  set  shift 2  si  sort  sos  stack 3 status 4 top  transfer 3  type 1  up 1"
;

# Input: {commands, minLens}
# Output: array of expansions or error markers corresponding to $words
def validate($words):
  .commands as $commands
  | .minLens as $minLens
  | [ $words[] as $word
     | ($word|length) as $wlen
     | first( range(0; $commands|length) as $i
         | $commands[$i]
         | select($minLens[$i] != 0 and $wlen >= $minLens[$i] and $wlen <= length)
         | ascii_upcase
         | select(startswith(($word|ascii_upcase))) )
       // "*error*" ];


# Output: {commands, minLens} corresponding to the $table string
def commands($table):
  [$table|splits("  *")] as $split_table
  | ($split_table|length) as $slen
  | {commands:[], minLens:[], i:0}
  | until(.found;
      .commands += [ $split_table[.i] ]
      | ($split_table[.i]|length) as $len
      | if (.i == $slen - 1)
        then .minLens += [$len]
        | .found = true
        else .
        end
      | .i += 1
      | ($split_table[.i] | try (tonumber) // null) as $num
      | if ($num != null)
        then .minLens += [ if ($num < $len) then $num else $len end ]
        | .i += 1
        | if (.i == $slen) then .found = true else . end
        else .minLens += [$len]
        end );

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

def task($sentence):
  [$sentence | splits("  *")] as $words
  | commands(table)
  | validate($words)
  | $words, .
  | map(lpad(10))
  | join(" ") ;

task("riG   rePEAT copies  put mo   rest    types   fup.    6       poweRin")
