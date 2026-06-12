USING: formatting kernel locals make math prettyprint ;

: cyclical-function ( n -- m ) dup * 1 + 255 mod ;

:: brent ( x0 quot -- λ μ )
    1 dup :> ( power! λ! )
    x0 :> tortoise!
    x0 quot call :> hare!
    [ tortoise hare = not ] [
        power λ = [
            hare tortoise!
            power 2 * power!
            0 λ!
        ] when
        hare quot call hare!
        λ 1 + λ!
    ] while

    0 :> μ!
    x0 dup tortoise! hare!
    λ [ hare quot call hare! ] times
    [ tortoise hare = not ] [
        tortoise quot call tortoise!
        hare quot call hare!
        μ 1 + μ!
    ] while
    λ μ ; inline

3 [ 20 [ dup , cyclical-function ] times ] { } make nip .
3 [ cyclical-function ] brent
"Cycle length: %d\nCycle start: %d\n" printf
