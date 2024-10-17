enum Direction
  RIGHT
  UP
  LEFT
  DOWN
end

def generate(n : Int32, i : Int32, c : Int32 | String)
  s = Array.new(n) { Array.new(n) { "" } }

  dir = Direction::RIGHT
  y = n // 2
  x = n % 2 == 0 ? y - 1 : y

  j = 1
  while j <= n * n - 1 + i
    s[y][x] = is_prime(j) ? j.to_s : c.to_s

    # printf "j: %s, x: %s, y: %s \n", j, x, y

    case dir
    when Direction::RIGHT
      dir = Direction::UP if x <= n - 1 && s[y - 1][x] == "" && j > i
    when Direction::UP
      dir = Direction::LEFT if s[y][x - 1] == ""
    when Direction::LEFT
      dir = Direction::DOWN if x == 0 || s[y + 1][x] == ""
    when Direction::DOWN
      dir = Direction::RIGHT if s[y][x + 1] == ""
    end

    case dir
    when Direction::RIGHT
      x += 1
    when Direction::UP
      y -= 1
    when Direction::LEFT
      x -= 1
    when Direction::DOWN
      y += 1
    end

    j += 1
  end

  s.map(&.join("\t")).join("\n")
end

def is_prime(n : Int32) : Bool
  return true if n == 2
  return false if n % 2 == 0 || n < 1

  i = 3
  while i <= Math.sqrt(n)
    return false if n % i == 0
    i += 2
  end

  true
end

puts generate 7, 1, "*"
