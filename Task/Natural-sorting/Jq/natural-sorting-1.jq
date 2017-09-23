def splitup:
  def tidy: if .[0] == "" then .[1:] else . end | if .[length-1] == "" then .[0:length-1] else . end ;

  # a and b are assumed to be arrays:
  def alternate(a;b):
    reduce range(0; [a,b] | map(length) | max) as $i ([]; . + [a[$i], b[$i]]);

  ([splits("[0-9]+")] | tidy) as $a
  | ([splits("[^0-9]+")] | tidy | map(tonumber)) as $n
  | (test("^[0-9]")) as $nfirst
  | if $nfirst then alternate($n; $a) else alternate($a; $n) end ;

# The following implementation of tr is more general than needed here, but the generality
# makes for adaptability.
# x and y should both be strings defining a character-by-character translation, like Unix/Linux "tr".
# if y is shorter than x, then y will in effect be padded with y's last character.
# The input may be a string or an exploded string (i.e. an array);
# the output will have the same type as the input.
def tr(x;y):
  type as $type
  | (x | explode) as $xe
  | (y | explode) as $ye
  | $ye[-1] as $last
  | if $type == "string" then explode else . end
  | map( . as $n | ($xe|index($n)) as $i | if $i then $ye[$i]//$last else . end)
  | if $type == "string" then implode else . end;

# NOTE: the order in which the filters are applied is consequential!
def natural_sort:
  def naturally:
    gsub("\\p{M}"; "")         # combining characters (accents, umlauts, enclosures, etc)
    | tr("ÀÁÂÃÄÅàáâãäåÇçÈÉÊËèéêëÌÍÎÏìíîïÒÓÔÕÖØòóôõöøÑñÙÚÛÜùúûüÝÿý";
         "AAAAAAaaaaaaCcEEEEeeeeIIIIiiiiOOOOOOooooooNnUUUUuuuuYyy")
    # Ligatures:
    | gsub("Æ"; "AE")
    | gsub("æ"; "ae")
    | gsub("\u0132"; "IJ")     #  Ĳ
    | gsub("\u0133"; "ij")     #  ĳ
    | gsub("\u0152"; "Oe")     #  Œ
    | gsub("\u0153"; "oe")     #  œ
    | gsub("ﬄ"; "ffl")
    | gsub("ﬃ"; "ffi")
    | gsub("ﬁ" ; "fi")
    | gsub("ﬀ" ; "ff")
    | gsub("ﬂ" ; "fl")
    # Illustrative replacements:
    | gsub("ß" ; "ss")         # German scharfes S
    | gsub("ſ|ʒ"; "s")         # LATIN SMALL LETTER LONG S and LATIN SMALL LETTER EZH

    | ascii_downcase
    | gsub("\\p{Cc}+";" ")     # control characters
    | gsub("^(the|a|an) "; "") # leading the/a/an (as words)
    | gsub("\\s+"; " ")        # whitespace
    | sub("^ *";"")            # leading whitespace
    | sub(" *$";"")            # trailing whitespace
    | splitup                  # embedded integers
    ;
  sort_by(naturally);
