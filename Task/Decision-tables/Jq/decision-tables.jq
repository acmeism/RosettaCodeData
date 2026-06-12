def get_response:
  input
  | if . == "Y" or . == "y" then "Y"
    elif . == "N" or . == "n" then "N"
    else null
    end;

def ask($prompt):
  def ask:
    $prompt|stderr
    | get_response
    | if . then . else ask end;
  ask;

def conditions: [
    ["Printer prints"                   , "NNNNYYYY"],
    ["A red light is flashing"          , "YYNNYYNN"],
    ["Printer is recognized by computer", "NYNYNYNY"]
];

def actions: [
    ["Check the power cable"               , "NNYNNNNN"],
    ["Check the printer-computer cable"    , "YNYNNNNN"],
    ["Ensure printer software is installed", "YNYNYNYN"],
    ["Check/replace ink"                   , "YYNNNYNN"],
    ["Check for paper jam"                 , "NYNYNNNN"]
];

def interact:
  conditions as $conditions
  | actions as $actions
  | ($conditions|length) as $nc
  | ($actions|length) as $na
  | ($conditions[0][1]|length) as $nr  # number of rules
  | 7 as $np                           # index of 'no problem' rule
  | "Please answer the following questions with a y or n:",
    ( reduce range(0; $nc) as $c ( null;
        .[$c] = ask("\($conditions[$c][0])? ") )) as $answers
     | ("\nRecommended action(s):",
        label $out
        | range(0; $nr) as $r
          | if all( range(0; $nc); $conditions[.][1][$r:$r+1] == $answers[.])
            then if $r == $np
                 then "None (no problem detected)."
                 else $actions[] | select(.[1][$r:$r+1] == "Y") | .[0]
                 end,
                 break $out
            else empty
            end ) ;

interact

