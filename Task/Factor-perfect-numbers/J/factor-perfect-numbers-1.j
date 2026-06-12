factors=: {{/:~*/@>,{(^ i.)&.>/0 1+__ q:y}}
fp1=: {{ {{y#~0*/ .=~2|/\&>y}} y<@#"1~1,.~1,.#:i.2^_2+#y }}@factors
fp2=: 2 %~/\&.> fp1
Fi=: i.0
F=: {{
 if. y>:#Fi do. Fi=: Fi{.~1+y end.
 if. (1<y)*0=y{Fi do. Fi=: Fi y}~ 1++/F y%}.factors y end.
 y{Fi
}}"0
