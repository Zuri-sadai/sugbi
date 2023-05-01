(ns sugbi.catalog.core
 (:require
  [clojure.set :as set]
  [sugbi.catalog.db :as db]
  [sugbi.catalog.open-library-books :as olb]))


(defn merge-on-key
  [k x y]
  (->> (concat x y)
       (group-by k)
       (map val)
       (mapv (fn [[x y]] (merge x y)))))


(def available-fields olb/relevant-fields)

;
(defn get-book
  [isbn fields]
  (when-let [db-book (db/get-book {:isbn isbn})]
    (let [open-library-book-info (olb/book-info isbn fields) 
          disponible (db/cuenta-book {:isbn isbn})]
      (-> db-book (merge open-library-book-info) (assoc :available (:count disponible))))))


(defn get-books
  [fields]
  (let [db-books                (db/get-books {})
        isbns                   (map :isbn db-books)
        open-library-book-infos (olb/multiple-book-info isbns fields)]
    (->>(merge-on-key
     :isbn
     db-books
     open-library-book-infos)
     (map (fn [book] (let [disponible(db/cuenta-book{:isbn(:isbn book)})]
                       (assoc book :available (:count disponible))))))))

;
(defn enriched-search-books-by-title
  [title fields]
  (let [db-book-infos           (db/matching-books title)
        isbns                   (map :isbn db-book-infos)
        open-library-book-infos (olb/multiple-book-info isbns fields)]
    (->>(merge-on-key
     :isbn
     db-book-infos
     open-library-book-infos)
     (map (fn [book] (let [disponible(db/cuenta-book{:isbn(:isbn book)})]
                       (assoc book :available (:count disponible))))))))

(defn checkout-book 
  [copia_id user_id]
  (db/checkout-book {:copia_id copia_id, :user_id user_id})
  (db/up-available {:copia_id copia_id, :available false,}))

(defn return-book 
  [copia_id user_id]
  (db/return-book {:copia_id copia_id, :user_id user_id})
  (db/up-available {:copia_id copia_id, :available true}))


;; Pruebas
; (db/insert-book! {:title "Harry Potter és a bölcsek köve", :isbn "9789639307223"})
; (db/insert-book! {:title "The power of now", :isbn "9781577311522"})

; (get-book "9789639307223" [:title, :publish-date, :publishers])
; (get-books [:title, :publish-date, :publishers])

; (enriched-search-books-by-title "Harry" [:title])
; (db/insert-copy {:book_id 1})
; (db/insert-copy {:book_id 2})

;(checkout-book 6, 1)
;(return-book 6, 1)

;(db/get-book-lendings {:user_id 1})