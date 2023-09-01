doors   = zeros(1,100); // 0: closed 1: open
for i = 1:100
    doors(i:i:100) = 1-doors(i:i:100)
end
doors
