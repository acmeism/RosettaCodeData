# when_index(cond;ary) returns the index of the first element in ary
# that satisfies cond; it uses a helper function that takes advantage
# of tail-recursion optimization in recent versions of jq.
def index_when(cond; ary):
  # state variable: counter
  def when: if . >= (ary | length) then null
            elif ary[.] | cond then .
            else (.+1) | when
            end;
  0 | when;

# Attempt to match a single letter with a block;
# return null if no match, else the remaining blocks
def match_letter(letter):
  . as $ary | index_when( index(letter); $ary ) as $ix
  | if $ix == null then null
    else del( .[$ix] )
    end;

# Usage: string | abc(blocks)
def abc(blocks):
  if length == 0 then true
  else
    .[0:1] as $letter
    | (blocks | match_letter( $letter )) as $blks
    | if $blks == null then false
      else .[1:] | abc($blks)
      end
  end;
