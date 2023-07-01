(defn words
  "Split string into words"
  [^String str]
  (.split (.stripLeading str) "\\s+"))

(defn join-words
  "Join words into a single string"
  ^String [strings]
  (String/join " " strings))

;; SOURCE: https://www.stackoverflow.com/a/38947571/12947681
(defn starts-with-ignore-case
  "Does string start with prefix (ignoring case)?"
  ^Boolean [^String string, ^String prefix]
  (.regionMatches string true 0 prefix 0 (count prefix)))

(defrecord CommandWord [^String word, ^long min-abbr-size])

(defn parse-cmd-table
  "Parse list of strings in command table into list of words and numbers
   If number is missing for any word, then the word is not included"
  ([cmd-table]
   (parse-cmd-table cmd-table 0 []))
  ([cmd-table i ans]
   (let [cmd-count (count cmd-table)]
     (if (= i cmd-count)
       ans
       (let [word (nth cmd-table i),
             [i num] (try [(+ i 2)
                           (Integer/parseInt ^String (nth cmd-table (inc i)))]
                          (catch NumberFormatException _
                            [(inc i) 0]))]
         (recur cmd-table i (conj ans (CommandWord. word num))))))))

;; cmd-table is a list of objects of type CommandWord (defined above)
(def cmd-table
  (->
   "add 1  alter 3  backup 2  bottom 1  Cappend 2  change 1  Schange  Cinsert 2  Clast 3
   compress 4 copy 2 count 3 Coverlay 3 cursor 3  delete 3 Cdelete 2  down 1  duplicate
   3 xEdit 1 expand 3 extract 3  find 1 Nfind 2 Nfindup 6 NfUP 3 Cfind 2 findUP 3 fUP 2
   forward 2  get  help 1 hexType 4  input 1 powerInput 3  join 1 split 2 spltJOIN load
   locate 1 Clocate 2 lowerCase 3 upperCase 3 Lprefix 2  macro  merge 2 modify 3 move 2
   msg  next 1 overlay 1 parse preserve 4 purge 3 put putD query 1 quit  read recover 3
   refresh renum 3 repeat 3 replace 1 Creplace 2 reset 3 restore 4 rgtLEFT right 2 left
   2  save  set  shift 2  si  sort  sos  stack 3 status 4 top  transfer 3  type 1  up 1"
   words
   parse-cmd-table))

(defn abbr?
  "Is abbr a valid abbreviation of this command?"
  ^Boolean [^String abbr, ^CommandWord cmd]
  (let [{:keys [word min-abbr-size]} cmd]
    (and (<= min-abbr-size (count abbr) (count word))
         (starts-with-ignore-case word abbr))))

(defn solution
  "Find word matching each abbreviation in input (or *error* if not found),
   and join results into a string"
  ^String [^String str]
  (join-words (for [abbr (words str)]
                (if-let [{:keys [word]} (first (filter #(abbr? abbr %) cmd-table))]
                  (.toUpperCase ^String word)
                  "*error*"))))

;; Print solution for given test case
(println (solution "riG   rePEAT copies  put mo   rest    types   fup.    6       poweRin"))
