C3 has four distinct comment types:

1. The normal // single line comment.
2. The classic /* ... */ multi-line C style comment, but unlike in C they are allowed to nest.
3. Documentation comments <* ... *> the text within these comments will be parsed as documentation and optional Contracts on the following code.
4. Shebang comment #!, which works like a single line comment, but is only valid as the first two characters in a file.
