library(stringi)

cmds_block <- "
Add ALTer  BAckup Bottom  CAppend Change SCHANGE  CInsert CLAst COMPress COpy
COUnt COVerlay CURsor DELete CDelete Down DUPlicate Xedit EXPand EXTract Find
NFind NFINDUp NFUp CFind FINdup FUp FOrward GET Help HEXType Input POWerinput
Join SPlit SPLTJOIN  LOAD  Locate CLocate  LOWercase UPPercase  LPrefix MACRO
MErge MODify MOve MSG Next Overlay PARSE PREServe PURge PUT PUTD  Query  QUIT
READ  RECover REFRESH RENum REPeat  Replace CReplace  RESet  RESTore  RGTLEFT
RIght LEft  SAVE  SET SHift SI  SORT  SOS  STAck STATus  TOP TRAnsfer Type Up"

cmds <- cmds_block %>% trimws() %>% stri_split_regex("\\s+") %>% unlist()

check_word <- function(inputw,comw) {
  inputl  <- nchar(inputw)
  coml    <- nchar(comw)
  cap_cnt <- stri_count_regex(comw,"[A-Z]")

  ifelse(cap_cnt != 0 && inputl >= cap_cnt && inputl <= coml &&
           stri_startswith_fixed(toupper(comw),toupper(inputw)),T,F)
}

# Inputs
intstr_list <- "riG   rePEAT copies  put mo   rest    types   fup.    6       poweRin" %>%
  stri_split_regex("\\s+") %>% unlist()

# Results
results <- sapply(intstr_list,\(y) {
  matc <- cmds[sapply(cmds,\(x) check_word(y,x))]
  ifelse(length(matc) != 0,toupper(matc[1]),"*error*")
})

print(results)
