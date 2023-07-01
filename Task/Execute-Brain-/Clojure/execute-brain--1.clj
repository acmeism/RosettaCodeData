(ns brainfuck)

(def ^:dynamic *input*)

(def ^:dynamic *output*)

(defrecord Data [ptr cells])

(defn inc-ptr [next-cmd]
  (fn [data]
    (next-cmd (update-in data [:ptr] inc))))

(defn dec-ptr [next-cmd]
  (fn [data]
    (next-cmd (update-in data [:ptr] dec))))

(defn inc-cell [next-cmd]
  (fn [data]
    (next-cmd (update-in data [:cells (:ptr data)] (fnil inc 0)))))

(defn dec-cell [next-cmd]
  (fn [data]
    (next-cmd (update-in data [:cells (:ptr data)] (fnil dec 0)))))

(defn output-cell [next-cmd]
  (fn [data]
    (set! *output* (conj *output* (get (:cells data) (:ptr data) 0)))
    (next-cmd data)))

(defn input-cell [next-cmd]
  (fn [data]
    (let [[input & rest-input] *input*]
      (set! *input* rest-input)
      (next-cmd (update-in data [:cells (:ptr data)] input)))))

(defn if-loop [next-cmd loop-cmd]
  (fn [data]
    (next-cmd (loop [d data]
                (if (zero? (get (:cells d) (:ptr d) 0))
                  d
                  (recur (loop-cmd d)))))))

(defn terminate [data] data)

(defn split-cmds [cmds]
  (letfn [(split [[cmd & rest-cmds] loop-cmds]
                 (when (nil? cmd) (throw (Exception. "invalid commands: missing ]")))
                 (case cmd
                       \[ (let [[c l] (split-cmds rest-cmds)]
                            (recur c (str loop-cmds "[" l "]")))
                       \] [(apply str rest-cmds) loop-cmds]
                       (recur rest-cmds (str loop-cmds cmd))))]
    (split cmds "")))

(defn compile-cmds [[cmd & rest-cmds]]
  (if (nil? cmd)
    terminate
    (case cmd
          \> (inc-ptr (compile-cmds rest-cmds))
          \< (dec-ptr (compile-cmds rest-cmds))
          \+ (inc-cell (compile-cmds rest-cmds))
          \- (dec-cell (compile-cmds rest-cmds))
          \. (output-cell (compile-cmds rest-cmds))
          \, (input-cell (compile-cmds rest-cmds))
          \[ (let [[cmds loop-cmds] (split-cmds rest-cmds)]
               (if-loop (compile-cmds cmds) (compile-cmds loop-cmds)))
          \] (throw (Exception. "invalid commands: missing ["))
          (compile-cmds rest-cmds))))

(defn compile-and-run [cmds input]
  (binding [*input* input *output* []]
    (let [compiled-cmds (compile-cmds cmds)]
     (println (compiled-cmds (Data. 0 {}))))
    (println *output*)
    (println (apply str (map char *output*)))))
