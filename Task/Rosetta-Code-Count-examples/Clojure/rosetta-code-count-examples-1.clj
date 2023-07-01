(ns count-examples
  (:import [java.net URLEncoder])
  (:use [clojure.contrib.http.agent :only (http-agent string)]
        [clojure.contrib.json :only (read-json)]
        [clojure.contrib.string :only (join)]))

(defn url-encode [v] (URLEncoder/encode (str v) "utf-8"))

(defn rosettacode-get [path params]
  (let [param-string (join "&" (for [[n v] params] (str (name n) "=" (url-encode v))))]
    (string (http-agent (format "http://www.rosettacode.org/w/%s?%s" path param-string)))))

(defn rosettacode-query [params]
  (read-json (rosettacode-get "api.php" (merge {:action "query" :format "json"} params))))

(defn list-cm
  ([params] (list-cm params nil))
  ([params continue]
     (let [cm-params (merge {:list "categorymembers"} params (or continue {}))
           result (rosettacode-query cm-params)]
       (concat (-> result (:query) (:categorymembers))
               (if-let [cmcontinue (-> result (:query-continue) (:categorymembers))]
                 (list-cm params cmcontinue))))))

(defn programming-tasks []
  (let [result (list-cm {:cmtitle "Category:Programming_Tasks" :cmlimit 50})]
    (map #(:title %) result)))

(defn task-count [task]
  [task (count
         (re-seq #"==\{\{header"
                 (rosettacode-get "index.php" {:action "raw" :title task})))])

(defn print-result []
  (let [task-counts (map task-count (programming-tasks))]
    (doseq [[task count] task-counts]
      (println (str task ":") count)
      (flush))
    (println "Total: " (reduce #(+ %1 (second %2)) 0 task-counts))))
