-- <statement> ::= <opcode> <address>
vmz.assm = function(self, source)
  local function oa2b(oper, addr) return oper * 32 + addr end
  local pc, objc = 0, { NOP=0, LDA=1, STA=2, ADD=3, SUB=4, BRZ=5, JMP=6, STP=7 }
  for oper, addr in source:gmatch("%s*(%a%a%a)%s*(%d*)") do
    self.mem[pc] = oa2b(objc[oper], tonumber(addr) or 0)
    pc = pc + 1
  end
  return self
end

srcfibo = "LDA 14 STA 15 ADD 13 STA 14 LDA 15 STA 13 LDA 16 SUB 17 BRZ 11 STA 16 JMP 0 LDA 14 STP 0 NOP 1 NOP 1 NOP 0 NOP 8 NOP 1"
print("Fibonacci = " .. vmz:boot():assm(srcfibo):exec().acc)

srclist = [[
  LDA 13  ADD 15  STA  5  ADD 16  STA  7  NOP  0  STA 14  NOP  0
  BRZ 11  STA 15  JMP  0  LDA 14  STP  0  LDA  0  NOP  0  NOP 28
  NOP  1  NOP  0  NOP  0  NOP  0  NOP  6  NOP  0  NOP  2  NOP 26
  NOP  5  NOP 20  NOP  3  NOP 30  NOP  1  NOP 22  NOP  4  NOP 24
]]
print("Linked list = " .. vmz:boot():assm(srclist):exec().acc)
