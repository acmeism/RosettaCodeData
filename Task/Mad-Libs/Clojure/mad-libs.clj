(ns magic.rosetta
    (:require [clojure.string :as str]))

(defn mad-libs
    "Write a program to create a Mad Libs like story.
     The program should read an arbitrary multiline story from input.
     The story will be terminated with a blank line.
     Then, find each replacement to be made within the story,
     ask the user for a word to replace it with, and make all the replacements.
     Stop when there are none left and print the final story.
     The input should be an arbitrary story in the form:
     <name> went for a walk in the park. <he or she>
     found a <noun>. <name> decided to take it home.
     Given this example, it should then ask for a name,
     a he or she and a noun (<name> gets replaced both times with the same value). "
    []
    (let
        [story (do
            (println "Please enter story:")
            (loop [story []]
                (let [line (read-line)]
                    (if (empty? line)
                        (str/join "\n" story)
                        (recur (conj story line))))))
         tokens (set (re-seq #"<[^<>]+>" story))
         story-completed (reduce
            (fn [s t]
                (str/replace s t (do
                    (println (str "Substitute " t ":"))
                    (read-line))))
            story
            tokens)]
        (println (str
            "Here is your story:\n"
            "------------------------------------\n"
            story-completed))))
; Sample run at REPL:
;
; user=> (magic.rosetta/mad-libs)
; Please enter story:
; One day <who> wake up at <where>.
; <who> decided to <do something>.
; While <who> <do something>, strange man
; appears and gave <who> a <thing>.

; Substitute <where>:
; Sweden
; Substitute <thing>:
; Nobel prize
; Substitute <who>:
; Bob Dylan
; Substitute <do something>:
; walk
; Here is your story:
; ------------------------------------
; One day Bob Dylan wake up at Sweden.
; Bob Dylan decided to walk.
; While Bob Dylan walk, strange man
; appears and gave Bob Dylan a Nobel prize.
