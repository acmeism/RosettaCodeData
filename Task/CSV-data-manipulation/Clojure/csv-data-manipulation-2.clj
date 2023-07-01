(require '[tech.v3.dataset :as ds]
         '[tech.v3.datatype.functional :as dfn])

(defn add-sum
  [dataframe]
  (assoc dataframe
         "SUM"
         (apply dfn/+ (map dataframe (ds/column-names dataframe)))))

(ds/write! (add-sum (ds/->dataset "resources/input.csv")) "resources/output.csv")
