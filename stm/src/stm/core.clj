(ns stm.core)

(def transfer-count (atom 0))

(let [fn-nonnegative #(>= % 0)]
  (def alice (ref 1000 :validator fn-nonnegative))
  (def bob (ref 2000 :validator fn-nonnegative)))

(defn transfer [from to amount]
  (dosync
   (swap! transfer-count inc)
   (alter from - amount)
   (alter to + amount)))

#_ (repeatedly 1 #(transfer alice bob 100))
#_ (println[@alice @bob @transfer-count])
