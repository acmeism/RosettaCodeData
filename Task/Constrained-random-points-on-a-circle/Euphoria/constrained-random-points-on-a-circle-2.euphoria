for i = 1 to length(validpoints) do --simple each pixel output to screen surface
    dummy=pixelColor(surface,validpoints[i][1]+18,validpoints[i][2]+18,#AA0202FF) --i is index number of each subsequence 'chunk'.
    --index 1 is x, index 2 is y, inside that chunk.
end for

for i = 1 to length(discardedpoints) do
    dummy=pixelColor(surface,discardedpoints[i][1]+18,discardedpoints[i][2]+52,#0202AAFF)
end for

for i = 1 to length(rand100points) do
    dummy=pixelColor(surface,rand100points[i][1]+55,rand100points[i][2]+52,#02AA02FF)
end for

dummy=boxColor(surface,0,71,395,111,#232323FF) --background box
dummy=stringColor(surface,0,73,sprintf("Number of valid coordinate pairs %d :", length(validpoints) ),#AA0202FF)

dummy=stringColor(surface,0,83,sprintf("Number of discarded coordinate pairs : %d", length(discardedpoints) ),#0202AAFF)

dummy=stringColor(surface,0,93,sprintf("Number of randomly picked coordinate pairs : %d", length(rand100points) ),#02AA02FF)
