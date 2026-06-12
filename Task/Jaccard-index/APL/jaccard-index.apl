task←{
    jaccard ← (≢∩)÷(≢∪)

    A ← ⍬
    B ← 1 2 3 4 5
    C ← 1 3 5 7 9
    D ← 2 4 6 8 10
    E ← 2 3 5 7
    F ← ,8

    '.ABCDEF' ⍪ 'ABCDEF' , ∘.jaccard⍨ A B C D E F
}
