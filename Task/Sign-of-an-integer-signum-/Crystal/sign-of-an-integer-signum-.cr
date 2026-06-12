struct Number
  def signum
    self > 0 ? 1 : self < 0 ? -1 : self
  end
end
