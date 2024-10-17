include std/console.e

sequence validpoints = {}
sequence discardedpoints = {}
sequence rand100points = {}
atom coordresult
integer randindex

--scan for all possible values. store discarded ones in another sequence, for extra reference.
for y = -15 to 15 do
    for x = -15 to 15 do

        coordresult = sqrt( x * x + y * y )

        if coordresult >= 10 and coordresult <= 15 then --if it would fall in the ring area
            validpoints &= {{x, y, coordresult}} --concatenate (add to the end) the coordinate pair x, y and the
            -- result into a subsequence of sequence validpoints
            else
                discardedpoints &= {{x, y, coordresult}} --else put it in the discarded sequence
        end if

    end for
end for

for i = 1 to 100 label "oneofhundred" do --make 100 random coordinate pairs
    randindex = rand(length(validpoints) ) --random value from 1 to the number of 3 value subsequences in validpoints (the data)

    if length(rand100points) = 0 then --if rand100points sequence is empty, add the first subsequence to it.
        rand100points &= {validpoints[randindex]}

        else --if it isn't empty, then..
            for j = 1 to length(rand100points) do --loop through each "data chunk" in rand100points

                if equal(validpoints[randindex], rand100points[j]) = 1 then --if any are the same as the randomly chosen chunk in
                    retry "oneofhundred" -- validpoints, then retry from one line below the "oneofhundred" loop without incrementing i.
                end if --the continue keyword would increment i instead.

            end for

            rand100points &= {validpoints[randindex]} --length of rand100points isnt 0 and no data chunks match ones that the program
            --already picked before, so add this subsequence chunk to rand100points.
    end if

end for

for i = 1 to 32 do --32 lines
    printf(1,"\n")
    for j = 1 to 32 label "xscan" do --32 characters on each line

        for k = 1 to length(rand100points) do --for every subsequence in this
            if rand100points[k][1]+16 = j and rand100points[k][2]+16 = i then --if the x and y coordinates in the picked points
                printf(1, 178) --(adjusted to minimum of 1,1) are at the same place as in the console output grid
                continue "xscan" --print a funny character and continue to the next "xscan"
            end if
        end for

        printf(1, 176) --if no picked points were there, print another funny character to represent a blank space

    end for
end for

printf(1, "\nNumber of valid coordinate pairs %d :", length(validpoints) )
printf(1, "\nNumber of discarded coordinate pairs : %d", length(discardedpoints) )
printf(1, "\nNumber of randomly picked coordinate pairs : %d\n", length(rand100points) )
any_key()
