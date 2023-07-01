 (ns clojure-sandbox.truthtables
  (:require [clojure.string :as s]
            [clojure.pprint :as pprint]))

;; Definitions of the logical operators
(defn !op [expr]
  (not expr))

(defn |op [e1 e2]
  (not (and (not e1)
            (not e2))))

(defn &op [e1 e2]
  (and e1 e2))

(defn ->op [e1 e2]
  (if e1
    e2
    true))

(def operators {"!" !op
                "|" |op
                "&" &op
                "->" ->op})

;; The evaluations of expressions always call the value method on sub-expressions
(defn evaluate-unary [operator operand valuemap]
  (let [operand-value (value operand valuemap)
        operator (get operators operator)]
    (operator operand-value)))

(defn evaluate-binary [o1 op o2 valuemap]
  (let [op1-value (value o1 valuemap)
        op2-value (value o2 valuemap)
        operator (get operators op)]
    (operator op1-value op2-value)))

;; Protocol to handle all kinds of expressions : unary (!x), binary (x & y), symbolic (x)
(defprotocol Expression
  (value [_ valuemap] "Returns boolean value of expression")) ;; this value map specifies the variables' truth values

(defrecord UnaryExpression [operator operand]
  Expression
  (value [self valuemap] (evaluate-unary operator operand valuemap)))

(defrecord BinaryExpression [op1 operator op2]
  Expression
  (value [self valuemap] (evaluate-binary op1 operator op2 valuemap)))

(defrecord SymbolExpression [operand]
  Expression
  (value [self valuemap] (get valuemap operand)))


;; Recursively create the right kind of boolean expression, evaluating from the right
(defn expression [inputs]
  (if (contains? operators (first inputs))
    (->UnaryExpression (first inputs) (expression (rest inputs)))
    (if (= 1 (count inputs))
      (->SymbolExpression (first inputs))
      (->BinaryExpression (->SymbolExpression (first inputs)) (nth inputs 1) (expression (nthrest inputs (- (count inputs) 1)))))))

;; This won't handle brackets, so it is all evaluated right to left
(defn parse [input-str]
  (-> input-str
      s/trim ;; remove leading/trailing space
      (s/split #"\s+"))) ;;remove intermediate spaces

(defn extract-var-names [inputs]
  "Get a list of variables that can have truth value"
  (->> inputs
       (filter (fn[i] (not (contains? operators i))))
       set))

(defn all-var-values [inputs]
  "Returns a list of all potential variable assignments"
  (let [vars (extract-var-names inputs)]
    (loop [vars-left vars
           outputs []]
      (if (empty? vars-left)
        outputs
        (let [this-var (first vars-left)]
          (if (empty? outputs)
            (recur (rest vars-left) [{this-var true} {this-var false}])
            (recur (rest vars-left)
                   (concat (map (fn[x] (assoc x this-var true)) outputs)
                           (map (fn[x] (assoc x this-var false)) outputs)))))))))

(defn truth-table [input]
  "Print out the truth table for an input string"
  (let [input-values (parse input)
        value-maps (all-var-values input-values)
        expression (expression input-values)]
    (value expression (first value-maps))
    (->> value-maps
         (map (fn [x] (assoc x input (value expression x))))
         pprint/print-table)))

(truth-table "! a | b") ;; interpreted as ! (a | b)
