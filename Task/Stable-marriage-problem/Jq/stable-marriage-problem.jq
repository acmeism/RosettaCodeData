# Generic utilities:
def debug(msg): (msg|debug) as $_ | .;

# Remove the key named $key from an object specified by the given path
def rmkey($key; path):
  path |= with_entries(select(.key != $key));

def printPairs:
  to_entries[]
  | "\(.key) \(.value)";

def debugPairs:
  . as $in
  | reduce to_entries[] as $x (null;
      $x | debug("\(.key) \(.value)") )
  | $in;

# The individual preferences
def mPref : {
    "abe": [
        "abi", "eve", "cath", "ivy", "jan",
        "dee", "fay", "bea", "hope", "gay"],
    "bob": [
        "cath", "hope", "abi", "dee", "eve",
        "fay", "bea", "jan", "ivy", "gay"],
    "col": [
        "hope", "eve", "abi", "dee", "bea",
        "fay", "ivy", "gay", "cath", "jan"],
    "dan": [
        "ivy", "fay", "dee", "gay", "hope",
        "eve", "jan", "bea", "cath", "abi"],
    "ed": [
        "jan", "dee", "bea", "cath", "fay",
        "eve", "abi", "ivy", "hope", "gay"],
    "fred": [
        "bea", "abi", "dee", "gay", "eve",
        "ivy", "cath", "jan", "hope", "fay"],
    "gav": [
        "gay", "eve", "ivy", "bea", "cath",
        "abi", "dee", "hope", "jan", "fay"],
    "hal": [
        "abi", "eve", "hope", "fay", "ivy",
        "cath", "jan", "bea", "gay", "dee"],
    "ian": [
        "hope", "cath", "dee", "gay", "bea",
        "abi", "fay", "ivy", "jan", "eve"],
    "jon": [
        "abi", "fay", "jan", "gay", "eve",
        "bea", "dee", "cath", "ivy", "hope"]
};

def wPref : {
    "abi": {
        "bob": 1, "fred": 2, "jon": 3, "gav": 4, "ian": 5,
        "abe": 6, "dan": 7, "ed": 8, "col": 9, "hal": 10},
    "bea": {
        "bob": 1, "abe": 2, "col": 3, "fred": 4, "gav": 5,
        "dan": 6, "ian": 7, "ed": 8, "jon": 9, "hal": 10},
    "cath": {
        "fred": 1, "bob": 2, "ed": 3, "gav": 4, "hal": 5,
        "col": 6, "ian": 7, "abe": 8, "dan": 9, "jon": 10},
    "dee": {
        "fred": 1, "jon": 2, "col": 3, "abe": 4, "ian": 5,
        "hal": 6, "gav": 7, "dan": 8, "bob": 9, "ed": 10},
    "eve": {
        "jon": 1, "hal": 2, "fred": 3, "dan": 4, "abe": 5,
        "gav": 6, "col": 7, "ed": 8, "ian": 9, "bob": 10},
    "fay": {
        "bob": 1, "abe": 2, "ed": 3, "ian": 4, "jon": 5,
        "dan": 6, "fred": 7, "gav": 8, "col": 9, "hal": 10},
    "gay": {
        "jon": 1, "gav": 2, "hal": 3, "fred": 4, "bob": 5,
        "abe": 6, "col": 7, "ed": 8, "dan": 9, "ian": 10},
    "hope": {
        "gav": 1, "jon": 2, "bob": 3, "abe": 4, "ian": 5,
        "dan": 6, "hal": 7, "ed": 8, "col": 9, "fred": 10},
    "ivy": {
        "ian": 1, "col": 2, "hal": 3, "gav": 4, "fred": 5,
        "bob": 6, "abe": 7, "ed": 8, "jon": 9, "dan": 10},
    "jan": {
        "ed": 1, "hal": 2, "gav": 3, "abe": 4, "bob": 5,
        "jon": 6, "col": 7, "ian": 8, "fred": 9, "dan": 10}
};

# pair/2 implements the Gale/Shapley algorithm.
# $pPref gives the proposer preferences (like mPref above)
# $rPref gives the recipient preferences (like wPref above)
# Output: a JSON object giving the matching as w:m pairs
def pair($pPref; $rPref):

  def undo:
    debug("engagement: \(.recipient) \(.proposer)")
    | .proposals[.recipient] = {proposer, pPref: .ppref, rPref: .rpref}
    | rmkey(.proposer; .pFree)
    | rmkey(.recipient; .rFree);

  # preferences must be saved in case engagement is broken;
  # they will be saved as: {proposer, pPref, rPref}
  { pFree: $pPref,
    rFree: $rPref,
    proposals: {} # key is recipient (w)
  }
  # WP pseudocode comments prefaced with WP: m is proposer, w is recipient.
  # WP: while ∃ free man m who still has a woman w to propose to
  | until (.pFree|length == 0;  # while there is a free proposer ...
      # pick a proposer
      (.pFree|to_entries[0]) as $me
      | .proposer = $me.key
      | .ppref    = $me.value
      | if .ppref|length == 0
        then .  # if proposer has no possible recipients, skip
        # WP: w = m's highest ranked woman to whom he has not yet proposed
        else
          .recipient = .ppref[0]   # highest ranked is first in list
          | .ppref = .ppref[1:]    # pop from list
          # WP: if w is free
          | .rpref = .rFree[.recipient]
          | if .rpref
            then # WP: (m, w) become engaged
	      undo
            else
              # WP: else some pair (m', w) already exists
              .s = .proposals[.recipient]  # get proposal saved preferences
              # WP: if w prefers m to m'
              | if .s.rPref[.proposer] < .s.rPref[.s.proposer]
                then debug("engagement broken: \(.recipient) \(.s.proposer)")
                  # WP: m' becomes free
                  | .pFree[.s.proposer] = .s.pPref # return proposer to the map
                  # WP: (m, w) become engaged
                  | .rpref = .s.rPref
		  | undo
                else
                  # WP: else (m', w) remain engaged
                  .pFree[.proposer] = .ppref # update preferences in map
                end
	    end
          end
    )  # end until
    # construct return value
    | reduce (.proposals|to_entries)[] as $me ({};
        .[$me.key] = $me.value.proposer ) ;

# return {result, emit} where .emit is an explanation
def determineStability($ps; $pPref; $rPref):
  $ps
  | debug("Determining the stability of the following pairings:")
  | debugPairs
  | to_entries as $pse
  | {i:0}
  | until(.emit or .i == ($ps|length);  # stop after detecting an instability
        $pse[.i].key   as $r
      | $pse[.i].value as $p
      | (first($pPref[$p][] as $rp
               | if ($r == $rp) then false
                 else $rPref[$rp] as $rprefs
                 | if ($rprefs[$p] < $rprefs[$ps[$rp]])
                   then "\ncauses instability because " +
                        "\($p) and \($rp) would prefer each other over their current pairings."
                   else empty
                   end
                 end ) // false) as $counterexample
        | if $counterexample == false then . else .emit = $counterexample end
      | .i += 1 )
  | if .emit then {result: false, emit} else {result: true} end ;

# Determine pairings using the Gale/Shapley algorithm and then perturb until instability arises.
def task:
  pair(mPref; wPref)
  | . as $ps
  | "Solution:", printPairs,
    # verify
    ((determineStability($ps; mPref; wPref)) as $return
     | ($return.emit // empty ),
       if $return.result == false
       then debug("invalid input")
       else
       "The result has been validated.",
       "Now perturb the result until validation fails.",
        (label $done
         | foreach range(0; $ps|length -1 ) as $start (.;
           .ps = $ps
           | (.ps|to_entries) as $kv
           | .w2[0] = $kv[$start].key
           | .m2[0] = $kv[$start].value
           | .w2[1] = $kv[$start+1].key
           | .m2[1] = $kv[$start+1].value
           | .emit = "\nExchanging partners of \(.m2[0]) and \(.m2[1])"
           | .ps[.w2[0]] = .m2[1]
           | .ps[.w2[1]] = .m2[0]
           # validate perturbed pairings
           | determineStability(.ps; mPref; wPref) as $result
           | .emit += $result.emit
           | .result = $result.result
           ;
           .emit,
           if .result == false then break $done else empty end
          ))
       end );

task
