function Bitmap:circle(x, y, r, c)
  local dx, dy, err = r, 0, 1-r
  while dx >= dy do
    self:set(x+dx, y+dy, c)
    self:set(x-dx, y+dy, c)
    self:set(x+dx, y-dy, c)
    self:set(x-dx, y-dy, c)
    self:set(x+dy, y+dx, c)
    self:set(x-dy, y+dx, c)
    self:set(x+dy, y-dx, c)
    self:set(x-dy, y-dx, c)
    dy = dy + 1
    if err < 0 then
      err = err + 2 * dy + 1
    else
      dx, err = dx-1, err + 2 * (dy - dx) + 1
    end
  end
end
