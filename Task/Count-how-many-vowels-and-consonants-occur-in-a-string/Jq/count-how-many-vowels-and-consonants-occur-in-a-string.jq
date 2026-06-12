def is_lowercase_vowel: IN("a","e","i","o","u");
def is_lowercase_letter: "a" <= . and . <= "z";
def is_lowercase_consonant: is_lowercase_letter and (is_lowercase_vowel|not);

def synopsis:
  # Output: a stream of the constituent characters
  def characters: ascii_downcase | explode[] | [.] | implode;
  # For the sake of DRYness:
  def s(stream; $vowels; $consonants):
    reduce stream as $c ({($vowels): 0, ($consonants):0};
      if $c|is_lowercase_vowel then .[$vowels] += 1
      elif $c|is_lowercase_consonant then .[$consonants] += 1
      else . end);

    s( characters; "vowels"; "consonants" )
  + s( [characters]|unique[]; "distinct_vowels"; "distinct_consonants" );

def task:
  def pp: "Synopsis for:", ., synopsis;

  "Forever HOPL",
  "Now is the time for all good men to come to the aid of their country."
  | pp, "";

task
