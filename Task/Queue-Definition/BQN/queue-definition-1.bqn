queue ← {
  data ← ⟨⟩
  Push ⇐ {data∾˜↩𝕩}
  Pop ⇐ {
    𝕊𝕩:
    0=≠data ? •Show "Cannot pop from empty queue";
    (data↓˜↩¯1)⊢⊑⌽data
  }
  Empty ⇐ {𝕊𝕩: 0=≠data}
  Display ⇐ {𝕊𝕩: •Show data}
}

q1 ← queue

•Show q1.Empty@
q1.Push 3
q1.Push 4
q1.Display@
•Show q1.Pop@
q1.Display@
