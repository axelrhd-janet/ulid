(def- crockford "0123456789ABCDEFGHJKMNPQRSTVWXYZ")

(defn- encode-time []
  (var millis (math/floor (* 1000 (os/clock))))
  (def res @[])
  (for i 0 10
    (def m (mod millis 32))
    (array/push res (string/from-bytes (get crockford m)))
    (set millis (/ (- millis m) 32)))
  (string/join (reverse res)))

(defn- encode-random []
  (string/join (map |(string/from-bytes (get crockford (mod $ 32))) (os/cryptorand 16))))

(defn new
  "Returns a new ULID in string form."
  []
  (string (encode-time) (encode-random)))

(defn timestamp
  "Extracts the timestamp in milliseconds from a ULID string."
  [id]
  (var ts 0)
  (loop [i :range [0 10]]
    (let [c (get id i)
          val (string/find (string/from-bytes c) crockford)]
      (set ts (+ (* ts 32) val))))
  ts)

(defn date
  "Extracts the creation date from a ULID as an os/date struct.
  Pass :local as second argument for local time, default is UTC."
  [id &opt local]
  (os/date (-> id timestamp (/ 1000) math/floor) local))

(defn valid?
  "Returns true if id is a syntactically valid ULID string.
  Checks length, Crockford base32 alphabet (case-insensitive), and that the
  encoded timestamp fits in 48 bits (i.e. the first character is 0-7)."
  [id]
  (and (string? id)
       (= (length id) 26)
       (let [upper (string/ascii-upper id)
             first-val (string/find (string/from-bytes (get upper 0)) crockford)]
         (and first-val
              (< first-val 8)
              (all |(string/find (string/from-bytes $) crockford) upper)))))
