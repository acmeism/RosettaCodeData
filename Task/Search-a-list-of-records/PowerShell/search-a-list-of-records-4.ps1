($cities | Where-Object -Property Population -LT 5)[0].Name
