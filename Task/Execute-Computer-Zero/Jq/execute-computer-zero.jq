### Utility
def trim: sub("^ +";"") | sub(" +$";"");

### Computer/Zero
def NOP: 0;
def LDA: 1;
def STA: 2;
def ADD: 3;
def SUB: 4;
def BRZ: 5;
def JMP: 6;
def STP: 7;

def ops: {"NOP": NOP, "LDA": LDA, "STA": STA, "ADD": ADD,
          "SUB": SUB, "BRZ": BRZ, "JMP": JMP, "STP": STP};

# Input: the program in the form of an array of strings,
#        each string corresponding to an input line of the form
#        "INSTR N" or "N"
# Output: an array of integers
def load:
  map([splits("  *")] as $split
      | $split[0] as $instr
      | (if ($split|length == 2) then $split[1]|tonumber
         else 0
         end) as $addr
      | if ops[$instr]
        then ops[$instr] * 32 + $addr
        else try ($instr|tonumber) catch 0
        end );

# input: an array as produced by `load`
def interp:
  { acc: 0, pc: 0, mem: .}
  | until(.break;
      (.mem[.pc] % 32) as $addr
      | ((.mem[.pc] - $addr) / 32) as $instr
      | .pc += 1
      | if   $instr == LDA then .acc = .mem[$addr]
        elif $instr == STA then .mem[$addr] = .acc
        elif $instr == ADD then .acc += .mem[$addr]
        | if .acc > 255 then .acc += -256 else . end
        elif $instr == SUB then .acc += (- .mem[$addr])
        | if .acc < 0 then .acc += 256 else . end
        elif $instr == BRZ
        then if .acc == 0 then .pc = $addr else . end
        elif $instr == JMP then .pc = $addr
        else .
        end
        | .break = $instr == STP or .pc > 31  )
    | .acc;

# Assume the input file consists of several programs, each structured as:
# ; program name
# one instruction per line
#
def task:
  def init: map_values(null);

  foreach (inputs, null) as $line ({};
    if $line == null then .program = .buffer
    elif $line[0:1] == ";" then init | .title = $line
    else ($line|trim) as $line
    | if $line == "" then .program = .buffer | .buffer = []
      else .buffer += [$line]
      end
    end)
  | .title as $title
  | .program
  | if length == 0 then empty
    else
    $title, (load|interp)
    end ;

task
