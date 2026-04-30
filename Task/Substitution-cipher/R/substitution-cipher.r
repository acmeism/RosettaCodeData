plain_chars <- c(letters, LETTERS)
cipher_chars <- sample(plain_chars, 52)
codex <- sapply(list(plain_chars, cipher_chars),
                function(v) paste0(v, collapse=""))

plaintext <- "The five boxing wizards jump quickly."
encode <- function(s) chartr(codex[1], codex[2], s)
decode <- function(s) chartr(codex[2], codex[1], s)
ciphertext <- plaintext |> encode() |> print()
ciphertext |> decode()
