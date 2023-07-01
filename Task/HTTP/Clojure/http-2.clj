(ns example
  (:use [clojure.contrib.http.agent :only (string http-agent)]))

(println (string (http-agent "http://www.rosettacode.org/")))
