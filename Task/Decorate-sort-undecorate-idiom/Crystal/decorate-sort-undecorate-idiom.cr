words = ["Rosetta", "Code", "is", "a", "programming", "chrestomathy", "site"]

# built-in #sort_by does this:
p words.sort_by {|word| { word.size, word } }

# possible implementation:
class Array(T)
  def keyed_sort (&key : T -> U) forall U
    self.map {|elt| { key.call(elt), elt } } # decorate
        .sort {|a, b| a.first <=> b.first }  # sort
        .map {|(_, elt)| elt }               # undecorate
  end
end

p words.keyed_sort {|word| { word.size, word } }
