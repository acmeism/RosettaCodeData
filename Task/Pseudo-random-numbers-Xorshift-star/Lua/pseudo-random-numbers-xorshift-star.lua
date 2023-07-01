function create()
    local g = {
        magic = 0x2545F4914F6CDD1D,
        state = 0,
        seed = function(self, num)
            self.state = num
        end,
        next_int = function(self)
            local x = self.state
            x = x ~ (x >> 12)
            x = x ~ (x << 25)
            x = x ~ (x >> 27)
            self.state = x
            local answer = (x * self.magic) >> 32
            return answer
        end,
        next_float = function(self)
            return self:next_int() / (1 << 32)
        end
    }
    return g
end

local g = create()
g:seed(1234567)
print(g:next_int())
print(g:next_int())
print(g:next_int())
print(g:next_int())
print(g:next_int())
print()

local counts = {[0]=0, [1]=0, [2]=0, [3]=0, [4]=0}
g:seed(987654321)
for i=1,100000 do
    local j = math.floor(g:next_float() * 5.0)
    counts[j] = counts[j] + 1
end
for i,v in pairs(counts) do
    print(i..': '..v)
end
