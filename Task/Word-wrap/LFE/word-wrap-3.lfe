> (set test-text (++ "Even today, with proportional fonts and complex layouts, there are still cases where you need to wrap text at a specified column. "
                     "The basic task is to wrap a paragraph of text in a simple way in your language. If there is a way to do this that is built-in, trivial, or "
                     "provided in a standard library, show that. Otherwise implement the minimum length greedy algorithm from Wikipedia.")
> (io:format (wrap-text text 80))
