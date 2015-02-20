function Num2Bin(n)
    let n = a:n
    let s = ""
    if n == 0
        let s = "0"
    else
        while n
            if n % 2 == 0
                let s = "0" . s
            else
                let s = "1" . s
            endif
            let n = n / 2
        endwhile
    endif
    return s
endfunction

echo Num2Bin(5)
echo Num2Bin(50)
echo Num2Bin(9000)
