BEGIN NOT ATOMIC
    DECLARE customer_1 TEXT DEFAULT 24;
    DECLARE customer_2 TEXT DEFAULT 777;
    PREPARE stmt FROM  'SELECT * FROM customer WHERE id = ?';
    EXECUTE stmt USING customer_1;
    EXECUTE stmt USING customer_2;
    DEALLOCATE PREPARE stmt;
END;
