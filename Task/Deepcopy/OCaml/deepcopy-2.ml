let copy h =
  { size = h.size;
    data = Array.copy h.data }
