SELECT
    IF(can_fly, 'Superman', 'Batman'),
    -- replace NULL with string
    IFNULL(can_fly, 'Not clear if this user can fly'),
    -- alias for IFNULL
    NVL(can_fly, 'Not clear if this user can fly'),
    -- replace '' with NULL
    NULLIF(can_fly, '')
    FROM user;
