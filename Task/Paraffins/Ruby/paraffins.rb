MAX_N = 500
BRANCH = 4

def tree(br, n, l=n, sum=1, cnt=1)
  for b in br+1 .. BRANCH
    sum += n
    return if sum >= MAX_N
    # prevent unneeded long math
    return if l * 2 >= sum and b >= BRANCH
    if b == br + 1
      c = $ra[n] * cnt
    else
      c = c * ($ra[n] + (b - br - 1)) / (b - br)
    end
    $unrooted[sum] += c if l * 2 < sum
    next if b >= BRANCH
    $ra[sum] += c
    (1...n).each {|m| tree(b, m, l, sum, c)}
  end
end

def bicenter(s)
  return if s.odd?
  aux = $ra[s / 2]
  $unrooted[s] += aux * (aux + 1) / 2
end

$ra       = [0] * MAX_N
$unrooted = [0] * MAX_N

$ra[0] = $ra[1] = $unrooted[0] = $unrooted[1] = 1
for n in 1...MAX_N
  tree(0, n)
  bicenter(n)
  puts "%d: %d" % [n, $unrooted[n]]
end
