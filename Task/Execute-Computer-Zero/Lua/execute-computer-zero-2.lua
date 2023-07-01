vmz.dism = function(self)
  local mnem, imax = { [0]="NOP", "LDA", "STA", "ADD", "SUB", "BRZ", "JMP", "STP" }
  for pc = 31,0,-1 do imax=pc if self.mem[pc]~=0 then break end end
  local result, pretty = "", "  %3s %2d\n"
  for i = 0, imax do
    local oper, addr = self.b2oa(self.mem[i])
    result = result .. pretty:format(mnem[oper], addr)
  end
  return result
end
vmz:boot():load({[0]=44,106,76,43,141,75,168,192,44,224,8,7,0,1})
print("Disassembly of 7 x 8 (PRE-RUN):")
print(vmz:dism())
print("Disassembly of 7 x 8 (POST-RUN):")
print(vmz:exec():dism())
