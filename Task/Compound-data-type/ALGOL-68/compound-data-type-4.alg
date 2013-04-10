MODE PERSON = STRUCT(
   STRING name,
   REAL age,
   REAL weight,
   UNION (
      STRUCT (REAL beard length),
      VOID
   ) gender details
);
