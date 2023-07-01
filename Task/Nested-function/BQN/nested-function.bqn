MakeList ← {
    nl←@+10 ⋄ s←𝕩 ⋄ i←0
    MakeItem ← {i+↩1 ⋄ (•Fmt i)∾s∾𝕩}
    (⊣∾nl∾⊢)´MakeItem¨"first"‿"second"‿"third"
}
