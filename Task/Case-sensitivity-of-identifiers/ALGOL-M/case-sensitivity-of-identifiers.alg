begin

string dog;
comment
  An attempt to declare Dog or DOG after declaring
  dog will result in a compile-time error ("Doubly
  Declared identifier");
dog := "Benjamin";
Dog := "Samba";
DOG := "Bernie";
write("There is just one dog named ", dog);

end
