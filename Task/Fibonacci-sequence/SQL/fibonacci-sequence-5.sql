SET @row_count := 10;
WITH RECURSIVE fibonacci_row (seq, current_value, next_value) AS
(
    (
        SELECT
            CAST(1 AS UNSIGNED INTEGER) AS seq,
            CAST(0 AS UNSIGNED INTEGER) AS current_value,
            CAST(1 AS UNSIGNED INTEGER) AS next_value
    ) UNION ALL (
        SELECT
            seq + 1 AS seq,
            next_value AS current_value,
            current_value + next_value AS next_value
        FROM fibonacci_row
        WHERE seq + 1 <= @row_count
    )
)
SELECT seq, current_value
    FROM fibonacci_row
;
