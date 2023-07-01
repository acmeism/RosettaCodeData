print("GLIDER:")
local life = Life:new(5,5)
life:set({ 2,1, 3,2, 1,3, 2,3, 3,3 })
for i = 1, 5 do
  life:render()
  life:evolve()
end
for i = 6,20 do life:evolve() end
life:render()

print()

print("LWSS:")
life = Life:new(10,7)
life:set({ 2,2, 5,2, 6,3, 2,4, 6,4, 3,5, 4,5, 5,5, 6,5 })
for i = 1, 5 do
  life:render()
  life:evolve()
end
for i = 6,20 do life:evolve() end
life:render()
