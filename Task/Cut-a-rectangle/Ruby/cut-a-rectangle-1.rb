def cut_it(h, w)
  if h.odd?
    return 0  if w.odd?
    h, w = w, h
  end
  return 1  if w == 1

  nxt = [[w+1, 1, 0], [-w-1, -1, 0], [-1, 0, -1], [1, 0, 1]]  # [next,dy,dx]
  blen = (h + 1) * (w + 1) - 1
  grid = [false] * (blen + 1)

  walk = lambda do |y, x, count=0|
    return count+1  if y==0 or y==h or x==0 or x==w
    t = y * (w + 1) + x
    grid[t] = grid[blen - t] = true
    nxt.each do |nt, dy, dx|
      count += walk[y + dy, x + dx]  unless grid[t + nt]
    end
    grid[t] = grid[blen - t] = false
    count
  end

  t = h / 2 * (w + 1) + w / 2
  if w.odd?
    grid[t] = grid[t + 1] = true
    count = walk[h / 2, w / 2 - 1]
    count + walk[h / 2 - 1, w / 2] * 2
  else
    grid[t] = true
    count = walk[h / 2, w / 2 - 1]
    return count * 2  if h == w
    count + walk[h / 2 - 1, w / 2]
  end
end

for w in 1..9
  for h in 1..w
    puts "%d x %d: %d" % [w, h, cut_it(w, h)]  if (w * h).even?
  end
end
