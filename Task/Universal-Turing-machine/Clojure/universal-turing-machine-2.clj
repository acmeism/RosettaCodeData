(def simple-incrementer
  (new-machine {:initial :q0
                :terminating [:qf]
                :rules [[:q0 1   1 :right :q0]
                        [:q0 \B  1 :stay  :qf]]}))
(deftest simple-incrementer-test
  (is (= [1 1 1 [1]] (simple-incrementer (tape [1 1 1] \B)))))


(def three-state-two-symbol-busy-beaver
  (new-machine {:initial :a
                :terminating [:halt]
                :rules [[:a 0  1 :right :b]
                        [:a 1  1 :left  :c]
                        [:b 0  1 :left  :a]
                        [:b 1  1 :right :b]
                        [:c 0  1 :left  :b]
                        [:c 1  1 :stay  :halt]]}))
(deftest three-state-two-symbol-busy-beaver-test
  (is (= [1 1 1 [1] 1 1] (three-state-two-symbol-busy-beaver (tape 0)))))


(def five-state-two-symbol-busy-beaver
  (new-machine {:initial :A
                :terminating [:H]
                :rules [[:A 0  1 :right :B]
                        [:A 1  1 :left  :C]
                        [:B 0  1 :right :C]
                        [:B 1  1 :right :B]
                        [:C 0  1 :right :D]
                        [:C 1  0 :left  :E]
                        [:D 0  1 :left  :A]
                        [:D 1  1 :left  :D]
                        [:E 0  1 :stay  :H]
                        [:E 1  0 :left  :A]]}))
(deftest five-state-two-symbol-busy-beaver-test
  (let [result (flatten (five-state-two-symbol-busy-beaver (tape 0)))
        freq (frequencies result)]
    (is (= 4098 (get freq 1)))
    (is (= 8191 (get freq 0)))))
