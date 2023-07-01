## Generic utilities

def enumerate(stream): foreach stream as $x (0; .+1; "\(.): \($x)");
def reverseString: explode | reverse | implode;

## UPC functions

def digitL: {
    "   ## #": 0,
    "  ##  #": 1,
    "  #  ##": 2,
    " #### #": 3,
    " #   ##": 4,
    " ##   #": 5,
    " # ####": 6,
    " ### ##": 7,
    " ## ###": 8,
    "   # ##": 9
};

def digitR: {
    "###  # ": 0,
    "##  ## ": 1,
    "## ##  ": 2,
    "#    # ": 3,
    "# ###  ": 4,
    "#  ### ": 5,
    "# #    ": 6,
    "#   #  ": 7,
    "#  #   ": 8,
    "### #  ": 9
};

def endSentinel: "# #";  #  also at start

def midSentinel:" # # ";

def decodeUpc:
  # Emit {rc: boolean, message: string}
  def decodeUpcImpl:

    # The "nil" result
    def nil: { rc: false, message: ""};

    (sub("^  *";"") | sub(" *$"; "")) as $upc
    | if ($upc|length != 95) then nil
      else [1, 3] as $oneThree
      | { pos: 0,
          digits: [],
          sum:  0 }
      | # end sentinel
        if $upc[.pos: .pos+3] != endSentinel
        then nil
        else .pos += 3
        # 6 left hand digits
        | .i = 0
        | until( .i == 6 or .i == null;
            .i += 1
            | digitL[$upc[.pos: .pos+7]] as $digit
            | if ($digit|not) then .i = null
              else .digits += [$digit]
              | .sum += $digit * $oneThree[(.digits|length) % 2]
              | .pos += 7
              end )
        | if .i == null then nil
          else # mid sentinel
            if $upc[.pos: .pos+5] != midSentinel
            then nil
            else .pos += 5
            # 6 right hand digits
            | .i = 0
            | until( .i == 6 or .i == null;
                .i += 1
                | digitR[$upc[.pos: .pos+7]] as $digit
                | if ($digit|not) then .i = null
                  else .digits += [$digit]
                  | .sum += $digit * $oneThree[(.digits|length) % 2]
                  | .pos += 7
                  end )
            | if .i == null then nil
              else # end sentinel
                if ($upc[.pos : .pos+3] != endSentinel) then false
                else if (.sum % 10 == 0)
                     then {rc: true,  message: "\(.digits) "}
                     else {rc: false, message: "Failed Checksum "}
                     end
                end
              end
            end
          end
        end
      end ;

    . as $in
    | decodeUpcImpl
    | .message
      + (if .rc then "Rightside Up"
         else ($in | reverseString | decodeUpcImpl)
         | .message
           + (if .rc then "Upside Down"
              else "Invalid digit(s)"
              end)
         end);

## Examples

def barcodes: [
    "         # #   # ##  #  ## #   ## ### ## ### ## #### # # # ## ##  #   #  ##  ## ###  # ##  ## ### #  # #       ",
    "        # # #   ##   ## # #### #   # ## #   ## #   ## # # # ###  # ###  ##  ## ###  # #  ### ###  # # #         ",
    "         # #    # # #  ###  #   #    # #  #   #    # # # # ## #   ## #   ## #   ##   # # #### ### ## # #         ",
    "       # # ##  ## ##  ##   #  #   #  # ###  # ##  ## # # #   ## ##  #  ### ## ## #   # #### ## #   # #        ",
    "         # # ### ## #   ## ## ###  ##  # ##   #   # ## # # ### #  ## ##  #    # ### #  ## ##  #      # #          ",
    "          # #  #   # ##  ##  #   #   #  # ##  ##  #   # # # # #### #  ##  # #### #### # #  ##  # #### # #         ",
    "         # #  #  ##  ##  # #   ## ##   # ### ## ##   # # # #  #   #   #  #  ### # #    ###  # #  #   # #        ",
    "        # # #    # ##  ##   #  # ##  ##  ### #   #  # # # ### ## ## ### ## ### ### ## #  ##  ### ## # #         ",
    "         # # ### ##   ## # # #### #   ## # #### # #### # # #   #  # ###  #    # ###  # #    # ###  # # #       ",
    "        # # # #### ##   # #### # #   ## ## ### #### # # # #  ### # ###  ###  # # ###  #    # #  ### # #         "
];

enumerate( barcodes[] | decodeUpc )
