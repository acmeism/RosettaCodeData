library(stringr)

#Read masses from a file to make code shorter
atomicmasses <- read.table("atomicmasses.txt",
                           sep=",",
                           col.names=c("element","mass"),
                           strip.white=TRUE)

molar_mass <- function(s){
  atoms <- str_extract_all(s, "[A-Z][a-z]*") |> unlist()
  vals <- sapply(atoms, function(s) with(atomicmasses, mass[element==s]))
  for(i in seq_along(atoms)){
    s <- str_replace(s, atoms[i], str_glue("+{vals[i]}*"))
  }
  s <- str_replace_all(s, "\\)(?=\\d)", ")*")
  s <- str_replace_all(s, "\\*(?=[^\\d])|\\*$", "")
  s <- str_replace_all(s, "(?<=\\w)\\(", "+(")
  eval(str2lang(s))
}

test_molecules <- c("H","H2","H2O","H2O2","(HO)2","Na2SO4","C6H12",
                    "COOH(C(CH3)2)3CH3","C6H4O2(OH)4","C27H46O","Uue")

sapply(test_molecules, molar_mass)
