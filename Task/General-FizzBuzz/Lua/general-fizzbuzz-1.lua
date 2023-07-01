function genFizz (param)
  local response
  print("\n")
  for n = 1, param.limit do
    response = ""
    for i = 1, 3 do
      if n % param.factor[i] == 0 then
        response = response .. param.word[i]
      end
    end
    if response == "" then print(n) else print(response) end
  end
end

local param = {factor = {}, word = {}}
param.limit = io.read()
for i = 1, 3 do
  param.factor[i], param.word[i] = io.read("*number", "*line")
end
genFizz(param)
