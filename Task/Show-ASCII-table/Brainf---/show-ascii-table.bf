> ++++++ ; 6 rows
> ++++ ++++ ++++ ++++ ; 16 columns
> ++++ ++++ ++++ ++++ ++++ ++++ ++++ ++++ ; 32: the starting character
<< ; move to row counter
[
 > ; move to the column counter
 [>  ; move to character
  .  ; print it
  +  ; increase it
  <- ; decrease  the column counter
 ]
 +++++ +++++.[-] ; print newline
 ++++ ++++ ++++ ++++ ; set column counter again
 <-] ; decrease row counter and loop
