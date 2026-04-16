(use ../ulid/init)

(def crockford "0123456789ABCDEFGHJKMNPQRSTVWXYZ")

# A fresh ULID is exactly 26 characters.
(let [id (new)]
  (assert (= (length id) 26)
          (string "expected 26 chars, got " (length id))))

# Every character is in the Crockford base32 alphabet.
(let [id (new)]
  (each byte id
    (assert (string/find (string/from-bytes byte) crockford)
            (string "invalid char in ULID: " (string/from-bytes byte)))))

# The encoded timestamp is within a second of the current wall clock.
(let [id (new)
      now-ms (math/floor (* 1000 (os/clock)))
      ts (timestamp id)]
  (assert (< (math/abs (- now-ms ts)) 1000)
          (string "timestamp " ts " diverges from now " now-ms)))

# Two ULIDs generated back to back must differ.
(assert (not= (new) (new)) "consecutive ULIDs collided")

# Two ULIDs generated in the same millisecond share the timestamp prefix
# and differ in the random suffix.
(let [a (new) b (new)]
  (when (= (timestamp a) (timestamp b))
    (assert (= (string/slice a 0 10) (string/slice b 0 10))
            "same-ms ULIDs should share the timestamp prefix")
    (assert (not= (string/slice a 10) (string/slice b 10))
            "same-ms ULIDs should differ in the random suffix")))

# `date` returns an os/date struct in UTC by default.
(let [id (new)
      d (date id)
      now (os/date)]
  (assert (= (d :year) (now :year)) "date year mismatch")
  (assert (= (d :month) (now :month)) "date month mismatch"))

# `date` with :local matches os/date with :local.
(let [id (new)
      d (date id :local)
      now (os/date (os/time) :local)]
  (assert (= (d :year) (now :year)) "local date year mismatch"))
