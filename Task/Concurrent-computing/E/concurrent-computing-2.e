def seedVat := <import:org.erights.e.elang.interp.seedVatAuthor>(<unsafe>)
for string in ["Enjoy", "Rosetta", "Code"] {
   seedVat <- (`
       fn string {
           println(string)
           currentVat <- orderlyShutdown("done")
       }
   `) <- get(0) <- (string)
}
