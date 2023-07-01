ThueMorse = {sequence = "0"}

function ThueMorse:show ()
    print(self.sequence)
end

function ThueMorse:addBlock ()
    local newBlock = ""
    for bit = 1, self.sequence:len() do
        if self.sequence:sub(bit, bit) == "1" then
            newBlock = newBlock .. "0"
        else
            newBlock = newBlock .. "1"
        end
    end
    self.sequence = self.sequence .. newBlock
end

for i = 1, 5 do
    ThueMorse:show()
    ThueMorse:addBlock()
end
