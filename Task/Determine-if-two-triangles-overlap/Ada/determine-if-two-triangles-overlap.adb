WITH Ada.Text_IO; USE Ada.Text_IO;

PROCEDURE Main IS
   TYPE Vertex IS MOD 3;
   TYPE Point IS ARRAY (0 .. 1) OF Float;
   TYPE Triangle IS ARRAY (Vertex) OF Point;
   TYPE Triangle_Vertices IS ARRAY (0 .. 5) OF Float;

   FUNCTION Same_Side (A, B, M, N : Point) RETURN Boolean IS
      FUNCTION Aff (U : Point) RETURN Float IS
        ((B (1) - A (1)) * (U (0) - A (0)) + (A (0) - B (0)) * (U (1) - A (1)));
   BEGIN
      RETURN Aff (M) * Aff (N) >= 0.0;
   END Same_Side;

   FUNCTION In_Side (T1 , T2 : Triangle) RETURN Boolean IS
     (FOR ALL V IN Vertex  =>
        (FOR Some P OF T2 => Same_Side (T1 (V + 1), T1 (V + 2), T1 (V), P)));

   FUNCTION Overlap (T1, T2 : Triangle) RETURN Boolean IS
     (In_Side (T1, T2) AND THEN  In_Side (T2, T1));

   FUNCTION "+" (T : Triangle_Vertices) RETURN Triangle IS
     ((T (0), T (1)), (T (2), T (3)), (T (4), T (5)));

   PROCEDURE Put (T1, T2 : Triangle_Vertices) IS
   BEGIN
      Put_Line (Overlap (+T1, +T2)'Img);
   END Put;

BEGIN
   Put ((0.0, 0.0, 5.0, 0.0, 0.0, 5.0), (0.0, 0.0, 5.0, 0.0, 0.0, 6.0));
   Put ((0.0, 0.0, 0.0, 5.0, 5.0, 0.0), (0.0, 0.0, 0.0, 5.0, 5.0, 0.0));
   Put ((0.0, 0.0, 5.0, 0.0, 0.0, 5.0), (-10.0, 0.0, -5.0, 0.0, -1.0, 6.0));
   Put ((0.0, 0.0, 5.0, 0.0, 2.5, 5.0), (0.0, 4.0, 2.5, -1.0, 5.0, 4.0));
   Put ((0.0, 0.0, 1.0, 1.0, 0.0, 2.0), (2.0, 1.0, 3.0, 0.0, 3.0, 2.0));
   Put ((0.0, 0.0, 1.0, 1.0, 0.0, 2.0), (2.0, 1.0, 3.0, -2.0, 3.0, 4.0));
   Put ((0.0, 0.0, 1.0, 0.0, 0.0, 1.0), (1.0, 0.0, 2.0, 0.0, 1.0, 1.0));
END Main;
