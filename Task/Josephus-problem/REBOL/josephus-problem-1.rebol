Rebol []

execute: func [death-list [block!] kill [integer!]] [
    assert [not empty? death-list]
    until [
        loop kill - 1 [append death-list take death-list]
        (1 == length? remove death-list)
    ]
]

prisoner: [] for n 0 40 1 [append prisoner n]
execute prisoner 3
print ["Prisoner" prisoner "survived"]
