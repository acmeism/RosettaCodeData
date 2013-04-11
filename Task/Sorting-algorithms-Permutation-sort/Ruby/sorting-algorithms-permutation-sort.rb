class Array
  def permutationsort
    permutations = permutation
    begin
      perm = permutations.next
    end until perm.sorted?
    perm
  end

  def sorted?
    each_cons(2).all? {|a, b| a <= b}
  end
end
