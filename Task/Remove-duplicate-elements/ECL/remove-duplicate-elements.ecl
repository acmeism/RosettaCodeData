inNumbers   := DATASET([{1},{2},{3},{4},{1},{1},{7},{8},{9},{9},{0},{0},{3},{3},{3},{3},{3}], {INTEGER Field1});
DEDUP(SORT(inNumbers,Field1));
