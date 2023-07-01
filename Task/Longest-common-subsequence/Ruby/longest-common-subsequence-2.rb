class LCS
  SELF, LEFT, UP, DIAG = [0,0], [0,-1], [-1,0], [-1,-1]

  def initialize(a, b)
    @m = Array.new(a.length) { Array.new(b.length) }
    a.each_char.with_index do |x, i|
      b.each_char.with_index do |y, j|
        match(x, y, i, j)
      end
    end
  end

  def match(c, d, i, j)
    @i, @j = i, j
    @m[i][j] = compute_entry(c, d)
  end

  def lookup(x, y)        [@i+x, @j+y]                      end
  def valid?(i=@i, j=@j)  i >= 0 && j >= 0                  end

  def peek(x, y)
    i, j = lookup(x, y)
    valid?(i, j) ? @m[i][j] : 0
  end

  def compute_entry(c, d)
    c == d ? peek(*DIAG) + 1 : [peek(*LEFT), peek(*UP)].max
  end

  def backtrack
    @i, @j = @m.length-1, @m[0].length-1
    y = []
    y << @i+1 if backstep? while valid?
    y.reverse
  end

  def backtrack2
    @i, @j = @m.length-1, @m[0].length-1
    y = []
    y << @j+1 if backstep? while valid?
    [backtrack, y.reverse]
  end

  def backstep?
    backstep = compute_backstep
    @i, @j = lookup(*backstep)
    backstep == DIAG
  end

  def compute_backstep
    case peek(*SELF)
    when peek(*LEFT) then LEFT
    when peek(*UP)   then UP
    else                  DIAG
    end
  end
end

def lcs(a, b)
  walker = LCS.new(a, b)
  walker.backtrack.map{|i| a[i]}.join
end

if $0 == __FILE__
  puts lcs('thisisatest', 'testing123testing')
  puts lcs("rosettacode", "raisethysword")
end
