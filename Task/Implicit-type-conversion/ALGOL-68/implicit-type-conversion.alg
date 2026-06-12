#!/usr/bin/a68g --script #
# -*- coding: utf-8 -*- #

main:(
# a representative sample of builtin types #
    BOOL b; INT bool width = 1;
    BITS bits; LONG BITS lbits;
    BYTES bytes; LONG BYTES lbytes; # lbytes := bytes is not illegal #
    [bits width]BOOL array bool;
    [long bits width]BOOL long array bool;
    CHAR c; INT char width = 1;
    STRING array char;

    SHORT SHORT INT ssi; SHORT INT si; INT i; LONG INT li; LONG LONG INT lli;
    SHORT SHORT REAL ssr; SHORT REAL sr; REAL r; LONG REAL lr; LONG LONG REAL llr;
    SHORT SHORT COMPL ssz; SHORT COMPL sz; COMPL z; LONG COMPL lz; LONG LONG COMPL llz;
    INT long long compl width = 2 * long long real width;

    STRUCT (BOOL b, CHAR c, INT i, REAL r, COMPL z)cbcirz;  # NO implicit casting #
    REF []INT rai;

    FORMAT long long real fmt = $g(-0,long long real width-2)$;
    FORMAT long long compl fmt = $f(long long real fmt)"+"f(long long real fmt)"i"$;
# type conversion stating points #
    b := TRUE;
    c := "1";
    ssi := SHORT SHORT 1234; i := 1234;
# a representative sample of implied casts for subtypes of personality INT/REAL/COMPL #
     si:=ssi;
      i:=ssi;  i:=si;
     li:=ssi; li:=si;  li:=i;
    lli:=ssi;lli:=si; lli:=i;  lli:=li;
    ssr:=ssi;
     sr:=ssr; sr:=ssi; sr:=si;
      r:=ssr;  r:=sr;   r:=ssi;  r:=si;   r:=i;
     lr:=ssr; lr:=sr;  lr:=r;   lr:=ssi; lr:=si;  lr:=i;   lr:=li;
    llr:=ssr;llr:=sr; llr:=r;  llr:=lr; llr:=ssi;llr:=si; llr:=i;  llr:=li; llr:=i;
    ssz:=ssr;ssz:=ssi;
     sz:=ssz; sz:=ssr; sz:=sr;  sz:=ssi; sz:=si;
      z:=ssz;  z:=sz;   z:=ssr;  z:=sr;   z:=r;    z:=ssi;  z:=si;   z:=i;
     lz:=ssz; lz:=sz;  lz:=z;   lz:=ssr; lz:=sr;  lz:=r;   lz:=lr;  lz:=ssi; lz:=si;  lz:=i;   lz:=li;
    llz:=ssz;llz:=sz; llz:=z;  llz:=lz; llz:=ssr;llz:=sr; llz:=r;  llz:=lr; llz:=r;  llz:=ssi;llz:=si; llz:=i;  llz:=li; llz:=lli;

# conversion branch SHORT SHORT INT => LONG LONG COMPL #
# a summary result, using the longest sizeof increasing casting path #
    printf((long long compl fmt,llz:=(llr:=(lr:=(i:=(si:=ssi)))),$
            $l"  was increasingly cast"$,
            $" from "g(-0)$, long long compl width, long long real width, long real width,
                            int width, short int width, short short int width, $" digits"$,
            $" from "g(-0)l$,ssi ));

# conversion branch BITS => []BOOL #
    bits := 16rf0f0ff00;
    lbits := bits;
    printf(($g$,"[]BOOL := LONG BITS := BITS - implicit widening: ",array bool := bits, $l$));

# conversion branch BYTES => []CHAR #
    bytes := bytes pack("0123456789ABCDEF0123456789abcdef");
    long array bool := LONG 2r111;
    printf(($g$,"[]CHAR := LONG BYTES := BYTES - implicit widening: ",array char := bytes, $l$));

# deproceduring conversion branch  PROC PROC PROC INT => INT #
    PROC pi = INT: i;
    PROC ppi = PROC INT: pi;
    PROC pppi = PROC PROC INT: ppi;
    printf(($g$,"PROC PROC PROC INT => INT - implicit deprocceduring^3: ",pppi, $l$));

# dereferencing conversion branch REF REF REF INT => INT #
    REF INT ri := i;
    REF REF INT rri := ri;
    REF REF REF INT rrri := rri;
    printf(($g$,"REF REF REF INT => INT - implicit dereferencing^3: ",rrri, $l$));

# rowing conversion branch INT => []INT => [,]INT => [,,]INT #
# a representative sample of implied casts, type pointer #
    rai := ai; # starts at the first element of ai #
    rai := i;  # an array of length 1 #

    FLEX[0]INT ai := i;
    FLEX[0,0]INT aai := ai;
    FLEX[0,0,0]INT aaai := aai;
    printf(($g$,"INT => []INT => [,]INT => [,,]INT - implicit rowing^3: ",aaai, $l$));

# uniting conversion branch UNION(VOID, INT) => UNION(VOID,INT,REAL) => UNION(VOID,INT,REAL,COMPL) #
    UNION(VOID,INT) ui := i;
    UNION(VOID,INT,REAL) uui := ui;
    UNION(VOID,INT,REAL,COMPL) uuui := uui;
    printf(($g$,"INT => UNION(VOID, INT) => UNION(VOID,INT,REAL,COMPL) - implicit uniting^3: ",(uuui|(INT i):i), $l$));
  SKIP
)
