def is_prime_word: all(gsub("[^A-Za-z]";"") | explode[]; is_prime);
