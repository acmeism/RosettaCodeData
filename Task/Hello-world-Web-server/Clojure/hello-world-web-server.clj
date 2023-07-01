(ns goodbye-world.handler
  (:require [compojure.core :refer :all]
            [compojure.handler :as handler]
            [compojure.route :as route]))

(defroutes app-routes
  (GET "/" [] "Goodbye, World!")
  (route/resources "/")
  (route/not-found "Not Found"))

(def app
  (handler/site app-routes))
