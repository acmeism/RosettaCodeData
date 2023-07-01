new File('.').traverse(
    type         : FILES,
    nameFilter   : ~/.*\.txt/,
    preDir       : { if (it.name == '.svn') return SKIP_SUBTREE },
) { println it }
