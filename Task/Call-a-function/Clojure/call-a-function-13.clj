;; Set up a variable that we will pass to a function
(def the-queen {:name "Elizabeth"
                :title "Your Majesty"
                :address "Buckingham Palace"
                :pets ["Corgi" "Horse"]})

;; A function to modify the data
(defn adopt-pet [person pet]
  "Adds pet to the person's list of pets"
  (update person
          :pets
          #(conj % pet)))

;; Calling the function returns a new data structure with the modified pets
(adopt-pet the-queen "Ferret"); => {:name "Elizabeth":title "Your Majesty" :address "Buckingham Palace" :pets ["Corgi" "Horse" "Ferret]}

;; The original data structure is not changed
the-queen; => {:name "Elizabeth" :title "Your Majesty" :address "Buckingham Palace" :pets ["Corgi" "Horse"]}
