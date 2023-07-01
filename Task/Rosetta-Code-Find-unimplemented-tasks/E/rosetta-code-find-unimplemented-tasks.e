#!/usr/bin/env rune

# NOTE: This program will not work in released E, because TermL is an
# imperfect superset of JSON in that version: it does not accept "\/".
# If you build E from the latest source in SVN then it will work.
#
# Usage: rosettacode-cat-subtract.e [<syntaxhighlight lang="e">]
#
# Prints a list of tasks which have not been completed in the language.
# If unspecified, the default language is E.

pragma.syntax("0.9")
pragma.enable("accumulator")

def termParser := <import:org.quasiliteral.term.makeTermParser>
def jURLEncoder := <unsafe:java.net.makeURLEncoder>

def urlEncode(text) {
  return jURLEncoder.encode(text, "UTF-8")
}

/** Convert JSON-as-term-tree to the corresponding natural E data structures. */
def jsonTermToData(term) {
    switch (term) {

        # JSON object to E map
        match term`{@assocs*}` {
            return accum [].asMap() for term`@{key :String}: @valueJson` in assocs {
                _.with(key, jsonTermToData(valueJson))
            }
        }

        # JSON array to E list
        match term`[@elements*]` {
            return accum [] for elem in elements { _.with(jsonTermToData(elem)) }
        }

        # Literals just need to be coerced
        match lit :any[String, int, float64] {
            return lit
        }

        # Doesn't support true/false/null, but we don't need that for this application.
    }
}

def fetchCategoryAccum(name, membersSoFar :Set, extraArgs) {
    stderr.println(`Fetching Category:$name $extraArgs...`)

    def categoryAPIResource := <http>[`//rosettacode.org/w/api.php?` +
        `action=query&list=categorymembers&cmtitle=Category:${urlEncode(name)}&` +
        `format=json&cmlimit=500&cmprop=title$extraArgs`]

    def members :=
      when (def responseJSON := categoryAPIResource <- getTwine()) -> {
        # stderr.println(`Fetched Category:$name $extraArgs, parsing...`)
        def response := jsonTermToData(termParser(responseJSON))

        # stderr.println(`Parsed Category:$name $extraArgs response, extracting data...`)
        def [
          "query" => ["categorymembers" => records],
          "query-continue" => continueData := null
        ] := response
        def members := accum membersSoFar for record in records { _.with(record["title"]) }

        switch (continueData) {
          match ==null {
            stderr.println(`Got all ${members.size()} for Category:$name.`)
            members
          }
          match ["categorymembers" => ["cmcontinue" => continueParam]] {
            stderr.println(`Fetched ${members.size()} members for Category:$name...`)
            fetchCategoryAccum(name, members, `&cmcontinue=` + urlEncode(continueParam))
          }
        }
    } catch p { throw(p) }

    return members
}

def fetchCategory(name) {
  return fetchCategoryAccum(name, [].asSet(), "")
}

# Interpret program arguments
def lang := switch (interp.getArgs()) {
  match [lang] { lang }
  match [] { "E" }
}

# Fetch categories
when (def allTasks := fetchCategory("Programming_Tasks"),
      def doneTasks := fetchCategory(lang),
      def omitTasks := fetchCategory(lang + "/Omit")
     ) -> {

    # Compute difference and report
    def notDoneTasks := allTasks &! (doneTasks | omitTasks)
    println()
    println("\n".rjoin(notDoneTasks.getElements().sort()))

} catch p {
    # Whoops, something went wrong
    stderr.println(`$p${p.eStack()}`)
}
