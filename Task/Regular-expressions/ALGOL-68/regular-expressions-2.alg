FORMAT pattern = $ddd" "c("cats","dogs")$;
FILE file; STRING book; associate(file, book);
on value error(file, (REF FILE f)BOOL: stop);
on format error(file, (REF FILE f)BOOL: stop);

book := "100 dogs";
STRUCT(INT count, type) dalmatians;

getf(file, (pattern, dalmatians));
print(("Dalmatians: ", dalmatians, new line));
count OF dalmatians +:=1;
printf(($"Gives: "$, pattern, dalmatians, $l$))
