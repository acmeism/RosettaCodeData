include get.e

function accending(sequence s)
    for i = 1 to length(s)-1 do
        if s[i]>s[i+1] then
            return 0
        end if
    end for
    return 1
end function

puts(1,"Given a jumbled list of the numbers 1 to 9,\n")
puts(1,"you must select how many digits from the left to reverse.\n")
puts(1,"Your goal is to get the digits in order with 1 on the left and 9 on the right.\n")

sequence nums
nums = repeat(0,9)
integer n,flp,tries,temp

-- initial values
for i = 1 to 9 do
    nums[i] = i
end for

while accending(nums) do -- shuffle
    for i = 1 to 9 do
        n = rand(9)
        temp = nums[n]
        nums[n] = nums[i]
        nums[i] = temp
    end for
end while

tries = 0
while 1 do
    printf(1,"%2d : ",tries)
    for i = 1 to 9 do
        printf(1,"%d ",nums[i])
    end for

    if accending(nums) then
        exit
    end if

    flp = prompt_number(" -- How many numbers should be flipped? ",{1,9})
    for i = 1 to flp/2 do
        temp = nums[i]
        nums[i] = nums[flp-i+1]
        nums[flp-i+1] = temp
    end for

    tries += 1
end while

printf(1,"\nYou took %d tries to put the digits in order.", tries)
