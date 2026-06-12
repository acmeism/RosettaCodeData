let examples = [[0x00uy];
                [0x00uy; 0x00uy];
                [0x00uy; 0x11uy; 0x00uy];
                [0x11uy; 0x22uy; 0x00uy; 0x33uy];
                [0x11uy; 0x22uy; 0x33uy; 0x44uy];
                [0x11uy; 0x00uy; 0x00uy; 0x00uy];
                [0x01uy..0xfeuy];
                [0x00uy..0xfeuy];
                [0x01uy..0xffuy];
                [0x02uy..0xffuy]@[0x00uy];
                [0x03uy..0xffuy]@[0x00uy; 0x01uy]]

examples|>List.iter(fun g->printf "\nexample\n    "
                           for n in g do printf "%4d" n
                           printfn "\nencoded"
                           let n=encode g
                           for n in n do printf "%4d" n
                           printf "\ndecoded\n    "
                           for n in decode n do printf "%4d" n
                           printfn "")
