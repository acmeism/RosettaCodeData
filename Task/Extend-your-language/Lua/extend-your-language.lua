-- Extend your language, in Lua, 6/17/2020 db
-- not to be taken seriously, ridiculous, impractical, esoteric, obscure, arcane ... but it works

-------------------
-- IMPLEMENTATION:
-------------------

function if2(cond1, cond2)
  return function(code)
    code = code:gsub("then2", "[3]=load[[")
    code = code:gsub("else1", "]],[2]=load[[")
    code = code:gsub("else2", "]],[1]=load[[")
    code = code:gsub("neither", "]],[0]=load[[")
    code = "return {" .. code .. "]]}"
    local block, err = load(code)
    if (err) then error("syntax error in if2 statement: "..err) end
    local tab = block()
    tab[(cond1 and 2 or 0) + (cond2 and 1 or 0)]()
  end
end

----------
-- TESTS:
----------

for i = 1, 2 do
  for j = 1, 2 do
    print("i="..i.." j="..j)

    if2 ( i==1, j==1 )[[ then2
      print("both conditions are true")
    else1
      print("first is true, second is false")
    else2
      print("first is false, second is true")
    neither
      print("both conditions are false")
    ]]

  end
end
