List.metaClass.hash = { list -> [delegate, list].transpose().collectEntries { [(it[0]): it[1]] } }
