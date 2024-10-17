SELECT
    -- return the first non-NULL value
    COALESCE(email, phone, telegram_id) AS contact,
    -- replace the key (1) with corresponding value ('email')
    CASE contact_type WHEN 1 THEN 'email' WHEN 2 THEN 'phone' ELSE NULL END AS contact_type,
    -- the first parameter must be a 1-based integer,
    -- ELT() returns the nth argument (eg, for n=1 it will return the email column)
    ELT(n, email, phone, telegram_id) AS preferred_contact,
    -- returns the index of the value that is equal to the 1st argument:
    -- in this example, 2
    FIELD('phone',  'email', 'phone', 'telegram_id') AS type;
    FROM user;
