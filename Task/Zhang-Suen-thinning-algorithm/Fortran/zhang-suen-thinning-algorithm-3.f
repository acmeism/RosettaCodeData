      FOR ALL (I = 2:N - 1, J = 2:M - 1)
       WHERE(DOT(I,J) .NE. 0) DOT(I,J) = ADJUST(DOT,I,J)
