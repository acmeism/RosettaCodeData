fn main() {
    // example program is current Brain**** solution to
    // Hello world/Text task.  only requires 10 bytes of data store!
    bf(10, '++++++++++[>+>+++>++++>+++++++>++++++++>+++++++++>++
++++++++>+++++++++++>++++++++++++<<<<<<<<<-]>>>>+.>>>
>+..<.<++++++++.>>>+.<<+.<<<<++++.<++.>>>+++++++.>>>.+++.
<+++++++.--------.<<<<<+.<+++.---.')
}

fn bf(d_len int, code string) {
    mut ds := []u8{len: d_len} // data store
    mut dp := 0               // data pointer
    for ip := 0; ip < code.len; ip++ {
        match code[ip] {
            `>` {
                dp++
            }
            `<` {
                dp--
            }
            `+` {
                ds[dp]++
            }
            `-` {
                ds[dp]--
            }
            `.` {
                print(ds[dp].ascii_str())
            }
            `,` {
                //fmt.Scanf("%c", &ds[dp])
                ds[dp] = -1 //TODO
            }
            `[` {
                if ds[dp] == 0 {
                    for nc := 1; nc > 0; {
                        ip++
                        if code[ip] == `[` {
                            nc++
                        } else if code[ip] == `]` {
                            nc--
                        }
                    }
                }
            }
            `]` {
                if ds[dp] != 0 {
                    for nc := 1; nc > 0; {
                        ip--
                        if code[ip] == `]` {
                            nc++
                        } else if code[ip] == `[` {
                            nc--
                        }
                    }
                }
            }
            else {}
        }
    }
}
