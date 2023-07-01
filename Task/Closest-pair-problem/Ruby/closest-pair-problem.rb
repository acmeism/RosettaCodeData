Point = Struct.new(:x, :y)

def distance(p1, p2)
  Math.hypot(p1.x - p2.x, p1.y - p2.y)
end

def closest_bruteforce(points)
  mindist, minpts = Float::MAX, []
  points.combination(2) do |pi,pj|
    dist = distance(pi, pj)
    if dist < mindist
      mindist = dist
      minpts = [pi, pj]
    end
  end
  [mindist, minpts]
end

def closest_recursive(points)
  return closest_bruteforce(points) if points.length <= 3
  xP = points.sort_by(&:x)
  mid = points.length / 2
  xm = xP[mid].x
  dL, pairL = closest_recursive(xP[0,mid])
  dR, pairR = closest_recursive(xP[mid..-1])
  dmin, dpair = dL<dR ? [dL, pairL] : [dR, pairR]
  yP = xP.find_all {|p| (xm - p.x).abs < dmin}.sort_by(&:y)
  closest, closestPair = dmin, dpair
  0.upto(yP.length - 2) do |i|
    (i+1).upto(yP.length - 1) do |k|
      break if (yP[k].y - yP[i].y) >= dmin
      dist = distance(yP[i], yP[k])
      if dist < closest
        closest = dist
        closestPair = [yP[i], yP[k]]
      end
    end
  end
  [closest, closestPair]
end

points = Array.new(100) {Point.new(rand, rand)}
p ans1 = closest_bruteforce(points)
p ans2 = closest_recursive(points)
fail "bogus!" if ans1[0] != ans2[0]

require 'benchmark'

points = Array.new(10000) {Point.new(rand, rand)}
Benchmark.bm(12) do |x|
  x.report("bruteforce") {ans1 = closest_bruteforce(points)}
  x.report("recursive")  {ans2 = closest_recursive(points)}
end
