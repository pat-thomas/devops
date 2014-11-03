(defproject clean-projects "0.1.0-SNAPSHOT"
  :description "FIXME: write description"
  :url "http://example.com/FIXME"
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"}
  :plugins [[lein-cljsbuild "1.0.3"]]
  :dependencies [[org.clojure/clojure       "1.6.0"]
                 [org.clojure/clojurescript "0.0-2371"]]
  :cljsbuild {:builds [{:source-paths ["src"]
                        :compiler     {:target        :nodejs
                                       :output-to     "target/js/main.js"
                                       :optimizations :simple
                                       :pretty-print  true}}]})
