Split-String "one^|uno||three^^^^|four^^^|^cuatro|" -Separator "|" -Escape "^" | ForEach-Object `
                                                                                        -Begin   {$n = 0} `
                                                                                        -Process {$n+= 1; "{0}: {1}" -f $n, $_}
