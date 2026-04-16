# Changelog
All notable changes to this project will be documented in this file.
Format for entries is <version-string> - release date.

## 0.2.0 - 2026-04-16
- `ulid/valid?` checks whether a string is a syntactically valid ULID
  (case-insensitive Crockford alphabet, 26 chars, timestamp within 48 bits).

## 0.1.0 - 2026-04-16
- Initial release.
- `ulid/new` generates a ULID.
- `ulid/timestamp` extracts the millisecond timestamp from a ULID.
- `ulid/date` returns the ULID's creation time as an `os/date` struct.
