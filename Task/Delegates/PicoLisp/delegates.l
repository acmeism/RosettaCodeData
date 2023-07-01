(class +Delegator)
# delegate

(dm operation> ()
   (if (: delegate)
      (thing> @)
      "default implementation" ) )


(class +Delegate)
# thing

(dm T (Msg)
   (=: thing Msg) )

(dm thing> ()
   (: thing) )


(let A (new '(+Delegator))
   # Without a delegate
   (println (operation> A))

   # With delegate that does not implement 'thing>'
   (put A 'delegate (new '(+Delegate)))
   (println (operation> A))

   # With delegate that implements 'thing>'
   (put A 'delegate (new '(+Delegate) "delegate implementation"))
   (println (operation> A)) )
