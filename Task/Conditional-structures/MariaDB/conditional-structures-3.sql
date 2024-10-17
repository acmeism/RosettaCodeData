BEGIN NOT ATOMIC
    IF @b IS TRUE THEN
        SELECT '@b is true';
    ELSEIF b IS FALSE THEN
        SELECT '@b is false';
    ELSE
        SELECT '@b is null';
    END;
    CASE @b
        WHEN TRUE THEN SELECT '@b is true';
        WHEN FALSE THEN SELECT '@b is false';
        ELSE SELECT '@b is null';
    END CASE;
END;
