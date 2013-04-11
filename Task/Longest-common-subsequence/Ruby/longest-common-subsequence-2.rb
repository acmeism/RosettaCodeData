class LcsWalker
  SELF, LEFT, UP, DIAG = [0,0], [0,-1], [-1,0], [-1,-1]

  def initialize(matrix); @m, @i, @j = matrix, 0, 0;        end
  def valid?(i=@i, j=@j); i >= 0 && j >= 0;                 end
  def match(c, d);        @m[@i][@j] = compute_entry(c, d); end
  def pos(i, j);          @i, @j = i, j;                    end
  def lookup(x, y);       [@i+x, @j+y];                     end

  def peek(x, y)
    i, j = lookup(x, y)
    valid?(i, j) ? @m[i][j] : 0
  end

  def compute_entry(c, d)
    c == d ? peek(*DIAG) + 1 : [peek(*LEFT), peek(*UP)].max
  end

  def backtrack
    Enumerator.new { |y| y << @i+1 if backstep while valid? }
  end

  def backstep
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
