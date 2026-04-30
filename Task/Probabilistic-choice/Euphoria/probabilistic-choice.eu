constant MAX = #3FFFFFFF
constant times = 1e6
atom d,e
sequence Mapps
Mapps = {
    { "aleph",  1/5,        0},
    { "beth",   1/6,        0},
    { "gimel",  1/7,        0},
    { "daleth", 1/8,        0},
    { "he",     1/9,        0},
    { "waw",    1/10,       0},
    { "zayin",  1/11,       0},
    { "heth",   1759/27720, 0}
}

for i = 1 to times do
    d = (rand(MAX)-1)/MAX
    e = 0
    for j = 1 to length(Mapps) do
        e += Mapps[j][2]
        if d <= e then
            Mapps[j][3] += 1
            exit
        end if
    end for
end for

printf(1,"Sample times: %d\n",times)
for j = 1 to length(Mapps) do
    d = Mapps[j][3]/times
    printf(1,"%-7s should be %f is %f | Deviatation %6.3f%%\n",
                {Mapps[j][1],Mapps[j][2],d,(1-Mapps[j][2]/d)*100})
end for
