# ulid

A [ULID](https://github.com/ulid/spec) implementation for
[Janet](https://janet-lang.org/).

ULIDs are 128-bit lexicographically sortable identifiers encoded as
26-character [Crockford base32](https://www.crockford.com/base32.html)
strings. The first 10 characters encode a millisecond timestamp; the last
16 characters are random.

```
  01ARZ3NDEK     TSV4RRFFQ69G5FAV

  timestamp         randomness
   48 bits            80 bits
```

Compared to UUIDs, ULIDs sort by creation time, are URL-safe, and are a
little shorter.

## Install

```
jpm install https://github.com/axelrhd-janet/ulid.git
```

## Usage

```janet
(import ulid)

(ulid/new)
# => "01JS8TAX5P7K3H2B4N9QWERTYZ"

(ulid/timestamp "01JS8TAX5P7K3H2B4N9QWERTYZ")
# => 1776319461850

(ulid/date "01JS8TAX5P7K3H2B4N9QWERTYZ")
# => {:year 2026 :month 3 :month-day 15 :hours 12 ...}  (UTC)

(ulid/date "01JS8TAX5P7K3H2B4N9QWERTYZ" :local)
# => same struct, but in local time

(ulid/valid? "01JS8TAX5P7K3H2B4N9QWERTYZ")
# => true
(ulid/valid? "not-a-ulid")
# => false
```

## API

### `(ulid/new)`

Returns a new ULID as a 26-character string.

### `(ulid/timestamp id)`

Extracts the embedded timestamp from a ULID string and returns it as
milliseconds since the Unix epoch.

### `(ulid/date id &opt local)`

Returns the ULID's creation time as an `os/date` struct. Pass `:local` as
the second argument for local time; defaults to UTC. The sub-second
portion of the timestamp is discarded — `os/date` has second resolution.

### `(ulid/valid? id)`

Returns true if `id` is a syntactically valid ULID string: exactly 26
characters from the Crockford base32 alphabet (case-insensitive), with
the encoded timestamp fitting in 48 bits (first character 0–7).

## Notes

- Randomness comes from `os/cryptorand`, giving 80 bits of entropy per
  ULID.
- There is no monotonic-within-millisecond guarantee: two ULIDs generated
  during the same millisecond share their timestamp prefix, but their
  sort order relative to each other is random.

## License

MIT — see [LICENSE](LICENSE).
