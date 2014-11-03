(ns clean-projects.core
  (:require [clean-projects.http :as http]
            [cljs.nodejs         :as nodejs]))

(nodejs/enable-util-print!)
(defn -main
  [& args]
  (-> (http/get-req "http://www.google.com"
                 (fn [resp]
                   (println "got resp:" (.-statusCode resp))))
      (.on "error" (fn [resp]
                     (println "got error:" (.-message resp))))))

(set! *main-cli-fn* -main)
