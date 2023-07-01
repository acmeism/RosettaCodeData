# -*- coding: utf-8 -*- #

COMMENT
  REQUIRES(
    MODE SORTELEMENT = mode of element of array to be sorted...
    OP < = (SORTELEMENT a, b)BOOL: a < b;
  )
END COMMENT

MODE SORTELEMENTCMP = PROC(SORTELEMENT,SORTELEMENT)BOOL;

# create a global sort procedure for convenience #
PROC(SORTELEMENT,SORTELEMENT)BOOL sort cmp default := (SORTELEMENT a, b)BOOL: a < b;
PROC sort cmp rev = (SORTELEMENT a, b)BOOL: NOT sort cmp default(a,b);

# Alternative gap calculations: #
#     ⌊n/2**k⌋; ⌊n/2⌋; Θ(n**2) [when n=2**p]; Donald Shell 1959 #
PROC sort gap shell = (INT k, n)INT: n OVER 2;
#     2 ⌊n/2**(k+1)⌋+1; 2 ⌊n/4⌋+1, ..., 3, 1; Θ(n**(3/2)); Frank & Lazarus, 1960 #
#     2**k-1; 1, 3, 7, 15, 31, 63, ...; Θ(n**(3/2)); Hibbard, 1963 #
#     2**k+1, prefixed with 1; 1, 3, 5, 9, 17, 33, 65, ...; Θ(n**(3/2)); Papernov & Stasevich, 1965 #
#     successive numbers of the form 2**p 3**q; 1, 2, 3, 4, 6, 8, 9, 12, ...; Θ(n log**2 n); Pratt 1971 #
#     (3**k-1)/2, not greater than ⌈n/3⌉; 1, 4, 13, 40, 121, ...; Θ(n**(3/2)); Knuth 1973 #
#     ∏a[q], where r=⌊√(2k+√(2k))⌋ and a[q]=min(n∈𝒩:n≥(5/2)**(q+1) and ∀ p:0≤ p<q → gcd(a[p],n)=1);
      limit where 0≤q<r and q≠(r**2+r)/2-k
         1, 3, 7, 21, 48, 112, ...; O(n e**√(8ln(5/2)ln n)); Incerpi & Sedgewick, 1985 #
#     4**k+3×2**(k-1)+1, prefixed with 1; 1, 8, 23, 77, 281, ...; Θ(n**(4/3)); Sedgewick, 1986 #
#     9(4**(k-1)-2**(k-1))+1, 4**(k+1)-6×2**k+1; 1, 5, 19, 41, 109, ...; Θ(n**(4/3)); Sedgewick, 1986 #
#     h[k]=max(⌊5h[k-1]/11⌋, 1), h[0]=n; ⌊5N/11⌋, ⌊5/11 ⌊5N/11⌋⌋, ..., 1; Θ(?); Gonnet & Baeza-Yates, 1991 #
PROC sort gap gonnet and baeza yates = (INT k, n)INT: IF n=2 THEN 1 ELSE n*5 OVER 11 FI;
#     ⌈(9**k-4**k)/(5×4**(k-1))⌉; 1, 4, 9, 20, 46, 103, ...; Θ(?); Tokuda, 1992 #
#     unknown; 1, 4, 10, 23, 57, 132, 301, 701; Θ(?); Ciura, 2001 #

# set default gap calculation #
PROC (INT #k#, INT #n#)INT sort gap := sort gap gonnet and baeza yates;

PROC shell sort in place = (REF []SORTELEMENT array, UNION(VOID, SORTELEMENTCMP) opt cmp)REF[]SORTELEMENT:(
  SORTELEMENTCMP cmp := (opt cmp|(SORTELEMENTCMP cmp): cmp | sort cmp default);
  INT n := ( UPB array + LWB array + 1 ) OVER 2; # initial gap #
  FOR k WHILE n NE 0 DO
    FOR index FROM LWB array TO UPB array DO
      INT i := index;
      SORTELEMENT element = array[i];
      WHILE ( i - LWB array >= n | cmp(element, array[i-n]) | FALSE ) DO
        array[i] := array[i-n];
        i -:= n
      OD;
      array[i] := element
    OD;
    n := sort gap(k,n)
  OD;
  array
);

PROC shell sort = ([]SORTELEMENT seq)[]SORTELEMENT:
  shell sort in place(LOC[LWB seq: UPB seq]SORTELEMENT:=seq, EMPTY);

PROC shell sort rev = ([]SORTELEMENT seq)[]SORTELEMENT:
  shell sort in place(LOC[LWB seq: UPB seq]SORTELEMENT:=seq, sort cmp rev);

SKIP
