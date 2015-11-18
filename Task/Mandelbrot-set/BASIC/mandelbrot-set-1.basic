SCREEN 13
WINDOW (-2, 1.5)-(2, -1.5)
FOR x0 = -2 TO 2 STEP .01
    FOR y0 = -1.5 TO 1.5 STEP .01
        x = 0
        y = 0

        iteration = 0
        maxIteration = 223

        WHILE (x * x + y * y <= (2 * 2) AND iteration < maxIteration)
            xtemp = x * x - y * y + x0
            y = 2 * x * y + y0

            x = xtemp

            iteration = iteration + 1
        WEND

        IF iteration <> maxIteration THEN
            c = iteration
        ELSE
            c = 0
        END IF

        PSET (x0, y0), c + 32
    NEXT
NEXT
