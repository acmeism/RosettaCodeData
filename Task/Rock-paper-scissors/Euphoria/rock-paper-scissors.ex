function weighted_rand(sequence table)
    integer sum,r
    sum = 0
    for i = 1 to length(table) do
        sum += table[i]
    end for

    r = rand(sum)
    for i = 1 to length(table)-1 do
        r -= table[i]
        if r <= 0 then
            return i
        end if
    end for
    return length(table)
end function

constant names = { "Rock", "Paper", "Scissors" }
constant winner = { "We tied.", "Meself winned.", "You win." }
integer user_action, my_action, key, win
sequence user_rec, score
user_rec = {1,1,1}
score = {0,0}

while 1 do
    my_action = remainder(weighted_rand(user_rec)+1,3)+1
    puts(1,"Your choice [1-3]:\n")
    puts(1,"  1. Rock\n  2. Paper\n  3. Scissors\n> ")
    key = -1
    while (key < '1' or key > '3') and key != 'q' do
        key = get_key()
    end while
    puts(1,key)
    puts(1,'\n')
    if key = 'q' then
        exit
    end if
    user_action = key-'0'
    win = remainder(my_action-user_action+3,3)
    printf(1,"You chose %s; I chose %s. %s\n",
        { names[user_action],
          names[my_action],
          winner[win+1] })

    if win then
        score[win] += 1
    end if
    printf(1,"\nScore %d:%d\n",score)
    user_rec[user_action] += 1
end while
