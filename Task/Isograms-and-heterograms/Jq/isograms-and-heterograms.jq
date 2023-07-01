# bag of words
def bow(stream):
  reduce stream as $word ({}; .[($word|tostring)] += 1);

# If the input string is an n-isogram then return n, otherwise 0:
def isogram:
  bow(ascii_downcase|explode[]|[.]|implode)
  | .[keys_unsorted[0]] as $n
  | if all(.[]; . == $n) then $n else 0 end ;

# Read the word list (inputs) and record the n-isogram value.
# Output: an array of [word, n] values
def words:
  [inputs
   | select(test("^[A-Za-z]+$"))
   | sub("^ +";"") | sub(" +$";"")
   | [., isogram] ];

# Input: an array of [word, n] values
# Sort by decreasing order of n;
# Then by decreasing order of word length;
# Then by ascending lexicographic order
def isograms:
  map( select( .[1] > 1) )
  | sort_by( .[0])
  | sort_by( - (.[0]|length))
  | sort_by( - .[1]);

# Input: an array of [word, n] values
# Sort as for isograms
def heterograms($minlength):
  map(select (.[1] == 1 and (.[0]|length) >= $minlength))
  | sort_by( .[0])
  | sort_by( - (.[0]|length));

words
| (isograms
   | "List of the \(length) n-isograms for which n > 1:",
     foreach .[] as [$word, $n] ({};
        .header = if $n != .group then "\nisograms of order \($n)" else null end
	| .group = $n;
	(.header | select(.)), $word ) ) ,

  (heterograms(11)
   | "\nList of the \(length) heterograms with length > 10:", .[][0])
