set x to text returned of (display dialog "Enter any real number:" default answer 42) as number
set iters to 0
repeat
    set x_new to 0.86 * (x + 3)
    set iters to iters + 1
    if x_new = x then
        return ((x_new as string) & " (" & iters as string) & " iterations before convergence)"
    end if
    set x to x_new
end repeat
