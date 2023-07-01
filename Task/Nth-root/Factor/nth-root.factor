USING: kernel locals math math.functions prettyprint ;

:: th-root ( a n -- a^1/n )
    a [
        a over n 1 - ^ /f
          over n 1 - *
        + n /f
        swap over 1e-5 ~ not
    ] loop ;

34 5 th-root .   ! 2.024397458499888
34 5 recip ^ .   ! 2.024397458499888
