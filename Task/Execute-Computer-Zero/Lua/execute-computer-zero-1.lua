vmz = {
  pc = 0,
  acc = 0,
  mem = { [0]=0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0 },
  b2oa = function(byte) return math.floor(byte / 32), byte % 32 end,
  boot = function(self) self.pc, self.acc = 0, 0 for pc=0,31 do self.mem[pc]=0 end return self end,
  load = function(self, bytes) for pc = 0, 31 do self.mem[pc]=bytes[pc] or 0 end return self end,
  clam = function(n) if n<0 then n=n+256 elseif n>255 then n=n-256 end return n end,
  opfn = {[0]=
    function(self,addr) self.pc=self.pc+1 return true end, -- NOP
    function(self,addr) self.acc=self.mem[addr] self.pc=self.pc+1 return true end, -- LDA
    function(self,addr) self.mem[addr]=self.acc self.pc=self.pc+1 return true end, -- STA
    function(self,addr) self.acc=self.clam(self.acc+self.mem[addr]) self.pc=self.pc+1 return true end, -- ADD
    function(self,addr) self.acc=self.clam(self.acc-self.mem[addr]) self.pc=self.pc+1 return true end, -- SUB
    function(self,addr) if (self.acc==0) then self.pc=addr else self.pc=self.pc+1 end return true end, -- BRZ
    function(self,addr) self.pc=addr return true end, -- JMP
    function(self,addr) self.pc=self.pc+1 return false end, -- STP
  },
  step = function(self)
    local oper, addr = self.b2oa(self.mem[self.pc])
    return self.opfn[oper](self,addr)
  end,
  exec = function(self)
    while self.pc < 32 and self:step() do end
    return self
  end,
}
-- object code derived from js sim code
print("2 + 2 = " .. vmz:boot():load({[0]=35,100,224,2,2}):exec().acc)
print("7 x 8 = " .. vmz:boot():load({[0]=44,106,76,43,141,75,168,192,44,224,8,7,0,1}):exec().acc)
