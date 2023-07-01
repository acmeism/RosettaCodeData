vmz.peek = function(self,addr) return self.mem[addr] end
vmz.poke = function(self,addr,byte) self.mem[addr]=byte end
vmz.entr = function(self,byte) self.mem[self.pc]=byte self.pc=self.pc+1 end
-- derived from the javascript "object code", rather than the descriptive "source code", as they appear to differ
srcpris = [[
  NOP  0 NOP  0 STP  0 NOP  0 LDA  3 SUB 29 BRZ 18 LDA  3 STA 29 BRZ 14 LDA  1 ADD 31 STA  1 JMP  2 LDA  0 ADD 31
  STA  0 JMP  2 LDA  3 STA 29 LDA  1 ADD 30 ADD  3 STA  1 LDA  0 ADD 30 ADD  3 STA  0 JMP  2 NOP  0 NOP  1 NOP  3
]]
print("\nPrisoner (priming) = " .. vmz:boot():assm(srcpris):exec().acc)
-- play five rounds,ie:  poke 0 or 1 into mem[3], pc+=1, exec again
mvnm = {[0]="coop", "defe"}
for r = 1, 5 do
  local move = r%2 -- artificial stupidity?
  vmz:entr(move)
  vmz:exec()
  print("Round: " .. r .. "  Move: " .. mvnm[move] .. "  Player: " .. vmz:peek(0) .. "  Computer: " .. vmz:peek(1))
end
