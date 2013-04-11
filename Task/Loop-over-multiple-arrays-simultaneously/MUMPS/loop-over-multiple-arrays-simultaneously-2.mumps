LOOPMULU
 N A,B,C,D,%
 S A(1)="a",A(2)="b",A(3)="c",A(4)="d"
 S B(1)="A",B(2)="B",B(3)="C",B(4)="D"
 S C(1)="1",C(2)="2",C(3)="3"
 ; will error    S %=$O(A("")) F  Q:%=""  W !,A(%),B(%),C(%) S %=$O(A(%))
 S %=$O(A("")) F  Q:%=""  W !,$G(A(%)),$G(B(%)),$G(C(%)) S %=$O(A(%))
 K A,B,C,D,%
