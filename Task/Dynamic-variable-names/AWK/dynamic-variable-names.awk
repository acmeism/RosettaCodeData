# syntax: GAWK -f DYNAMIC_VARIABLE_NAMES.AWK
# Variables created in GAWK's internal SYMTAB (symbol table) can only be accessed via SYMTAB[name]
BEGIN {
    PROCINFO["sorted_in"] = "@ind_str_asc"
    show_symbol_table()
    while (1) {
      printf("enter variable name? ")
      getline v_name
      if (v_name in SYMTAB) {
        printf("name already exists with a value of '%s'\n",SYMTAB[v_name])
        continue
      }
      if (v_name ~ /^$/) {
        printf("name is null\n")
        continue
      }
      if (v_name !~ /^[A-Za-z][A-Za-z0-9_]*$/) {
        printf("name illegally constructed\n")
        continue
      }
      break
    }
    printf("enter value? ")
    getline v_value
    SYMTAB[v_name] = v_value
    printf("variable '%s' has been created and assigned the value '%s'\n\n",v_name,v_value)
    show_symbol_table()
    exit(0)
}
function show_symbol_table(  count,i) {
    for (i in SYMTAB) {
      printf("%s ",i)
      if (isarray(SYMTAB[i])) { count++ }
    }
    printf("\nsymbol table contains %d names of which %d are arrays\n\n",length(SYMTAB),count)
}
