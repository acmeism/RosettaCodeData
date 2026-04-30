require "./pixmap"

class Pixmap
  def flood_fill (x, y, color)
    old_color = self[x, y]
    queue = Deque(Int32).new
    width = @width
    size = @data.size
    idx = y * width + x
    queue << idx

    until queue.empty?
      idx = queue.shift
      next unless @data[idx] == old_color
      start = idx
      # go left
      limit = start // width * width
      while idx >= limit && @data[idx] == old_color
        @data[idx] = color
        up, dn = idx - width, idx + width
        queue << up  if up >= 0   && @data[up] == old_color
        queue << dn  if dn < size && @data[dn] == old_color
        idx -= 1
      end
      # go right
      limit = (start + width) // width * width
      idx = start + 1
      while idx < limit && @data[idx] == old_color
        @data[idx] = color
        up, dn = idx - width, idx + width
        queue << up  if up >= 0   && @data[up] == old_color
        queue << dn  if dn < size && @data[dn] == old_color
        idx += 1
      end
    end
  end
end
