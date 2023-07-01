WITH KnapsackItems (item, [weight], value) AS
(
    SELECT 'map',9,  150
    UNION ALL SELECT 'compass',13,  35
    UNION ALL SELECT 'water',153,  200
    UNION ALL SELECT 'sandwich',50,  160
    UNION ALL SELECT 'glucose',15,  60
    UNION ALL SELECT 'tin',68,  45
    UNION ALL SELECT 'banana',27,  60
    UNION ALL SELECT 'apple',39,  40
    UNION ALL SELECT 'cheese',23,  30
    UNION ALL SELECT 'beer',52,  10
    UNION ALL SELECT 'suntan cream',11,  70
    UNION ALL SELECT 'camera',32,  30
    UNION ALL SELECT 'T-shirt',24,  15
    UNION ALL SELECT 'trousers',48,  10
    UNION ALL SELECT 'umbrella',73,  40
    UNION ALL SELECT 'waterproof trousers',42,  70
    UNION ALL SELECT 'waterproof overclothes',43,  75
    UNION ALL SELECT 'note-case',22,  80
    UNION ALL SELECT 'sunglasses',7,  20
    UNION ALL SELECT 'towel',18,  12
    UNION ALL SELECT 'socks',4,  50
    UNION ALL SELECT 'book',30,  10
)
SELECT *
INTO #KnapsackItems
FROM KnapsackItems;

WITH UNIQUEnTuples (n, Tuples, ID, [weight], value) AS (
    SELECT 1, CAST(item AS VARCHAR(8000)), item, [weight], value
    FROM #KnapsackItems
    UNION ALL
    SELECT 1 + n.n, t.item + ',' + n.Tuples, item, n.[weight] + t.[weight], n.value + t.value
    FROM UNIQUEnTuples n
    CROSS APPLY (
        SELECT item, [weight], value
        FROM #KnapsackItems t
        WHERE t.item < n.ID AND n.[weight] + t.[weight] < 400) t
    )
SELECT TOP 5 *
FROM UNIQUEnTuples
ORDER BY value DESC, n, Tuples;

GO
DROP TABLE #KnapsackItems;
