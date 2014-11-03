(ns clean-projects.http
  (:require [cljs.nodejs :as nodejs]))

(def ^private http-lib (nodejs/require "http"))

(defn get-req
  [url callback]
  (.get http-lib url callback))
