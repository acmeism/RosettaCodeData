def trim: sub("^  *";"") | sub("  $";"");

# Each item in the stream should be a string with $n names
def minimum_abbreviation_lengths(stream; $n):
  foreach (stream|trim) as $line ({i: 0};
    .i+=1
    | if $line == "" then .emit = ""
      else [$line|splits("  *")] as $days
      | if ($days|length != $n) then .emit = "WARNING: line \(.i) does not have \($n) tokens"
        elif ($days|unique|length < $n)  # some days have the same name
        then .emit = "∞: \($line)"
        else .len = 1
	| .emit = false
        | until(.emit;
	    .len as $len
            | if ($days|map(.[:$len])|unique|length == $n)
              then .emit = "\($len): \($line)"
              else .len += 1
	      end)
	end
      end;
      .emit) ;

minimum_abbreviation_lengths(inputs; 7)
