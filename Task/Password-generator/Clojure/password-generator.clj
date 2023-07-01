(ns pwdgen.core
  (:require [clojure.set :refer [difference]]
            [clojure.tools.cli :refer [parse-opts]])
  (:gen-class))

(def minimum-length 4)
(def cli-options
  [["-c" "--count NUMBER" "Number of passwords to generate"
    :default 1
    :parse-fn #(Integer/parseInt %)]
   ["-l" "--length NUMBER" "Length of the generated passwords"
    :default 8
    :parse-fn #(Integer/parseInt %)
    :validate [#(<= minimum-length %) (str "Must be greater than or equal to " minimum-length)]]
   ["-x", "--exclude-similar" "Exclude similar characters"]
   ["-h" "--help"]])

(def lowercase (map char (range (int \a) (inc (int \z)))))
(def uppercase (map char (range (int \A) (inc (int \Z)))))
(def numbers (map char (range (int \0) (inc (int \9)))))
(def specials (remove (set (concat lowercase uppercase numbers [\` \\])) (map char (range (int \!) (inc (int \~))))))
(def similar #{\I \l \1 \| \O \0 \5 \S \2 \Z})

(defn sanitize [coll options]
  (if (:exclude-similar options) (into '() (difference (set coll) similar)) coll))

(defn generate-password [options]
  (let [upper (rand-nth (sanitize uppercase options))
        lower (rand-nth (sanitize lowercase options))
        number (rand-nth (sanitize numbers options))
        special (rand-nth (sanitize specials options))
        combined (shuffle (sanitize (concat lowercase uppercase numbers specials) options))]
    (shuffle (into (list upper lower number special) (take (- (:length options) minimum-length) combined)))))

(defn -main [& args]
  (let [{:keys [options summary]} (parse-opts args cli-options)]
    (if (:help options) (println summary)
      (dotimes [n (:count options)]
        (println (apply str (generate-password options)))))))
