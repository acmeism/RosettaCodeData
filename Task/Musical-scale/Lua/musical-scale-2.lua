staff = {
  lines = { "", "", "", "", "", "", "", "", "", "", "" },
  nnotes = 0,
  measure = function(self)
    for i, line in ipairs(self.lines) do
      self.lines[i] = line .. (i<#self.lines-1 and "|" or " ")
    end
  end,
  play = function(self, note)
    if self.nnotes%4==0 then self:measure() end
    local n = #self.lines-note
    for i, line in ipairs(self.lines) do
      local linechar = (i%2==0) and " " or "-"
      local fillchar = (i<#self.lines) and linechar or " "
      self.lines[i] = line .. (i==n and linechar.."@"..linechar..fillchar or (i==n-1 or i==n-2) and string.rep(fillchar,2).."|"..fillchar or string.rep(fillchar,4))
    end
    self.nnotes = self.nnotes + 1
  end,
  dump = function(self)
    for i, line in ipairs(self.lines) do print(line) end
  end
}
for note = 0,7 do
  staff:play(note)
end
staff:measure()
staff:dump()
