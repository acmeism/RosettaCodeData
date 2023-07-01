BSearch ← {
  BS ⟨a, value⟩:
  BS ⟨a, value, 0, ¯1+≠a⟩;
  BS ⟨a, value, low, high⟩:
  mid ← ⌊2÷˜low+high
  {
    high<low ? ¯1;
    (mid⊑a)>value ? BS ⟨a, value, low, mid-1⟩;
    (mid⊑a)<value ? BS ⟨a, value, mid+1, high⟩;
    mid
  }
}

•Show BSearch ⟨8‿30‿35‿45‿49‿77‿79‿82‿87‿97, 97⟩
