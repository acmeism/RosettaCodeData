with Ada.Text_IO;
use Ada.Text_IO;

procedure CountQueens is
    function Queens (N : Integer) return Long_Integer is
        A : array (0 .. N) of Integer;
        U : array (0 .. 2 * N - 1) of Boolean := (others => true);
        V : array (0 .. 2 * N - 1) of Boolean := (others => true);
        M : Long_Integer := 0;

        procedure Sub (I: Integer) is
            K, P, Q: Integer;
        begin
            if N = I then
                M := M + 1;
            else
                for J in I .. N - 1 loop
                    P := I + A (J);
                    Q := I + N - 1 - A (J);
                    if U (P) and then V (Q) then
                        U (P) := false;
                        V (Q) := false;
                        K := A (I);
                        A (I) := A (J);
                        A (J) := K;
                        Sub (I + 1);
                        U (P) := true;
                        V (Q) := true;
                        K := A (I);
                        A (I) := A (J);
                        A (J) := K;
                    end if;
                end loop;
            end if;
        end Sub;
    begin
        for I in 0 .. N - 1 loop
            A (I) := I;
        end loop;
        Sub (0);
        return M;
    end Queens;
begin
    for N in 1 .. 16 loop
        Put (Integer'Image (N));
        Put (" ");
        Put_Line (Long_Integer'Image (Queens (N)));
    end loop;
end CountQueens;
