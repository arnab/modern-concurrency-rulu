(ns stm.core)

(def transfer-count (atom 0))

(let [fn-positive #(>= % 0)]
  (def alice (ref 1000 :validator fn-positive))
  (def bob (ref 2000 :validator fn-positive)))

(defn transfer [from to amount]
  (dosync
   (swap! transfer-count inc)
   (alter from - amount)
   (alter to + amount)))

#_ (repeatedly 25 #(transfer alice bob 100))
#_ (println[@alice @bob @transfer-count])
