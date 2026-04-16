# CLAUDE.md

A minimal [ULID](https://github.com/ulid/spec) implementation for Janet.

## Layout

- `ulid/init.janet` — the entire library (about 35 lines).
- `test/basic.janet` — tests.
- `project.janet` — jpm project definition.

## Commands

```
jpm test        # run the test suite
jpm install     # install locally
```

## Implementation notes

- `encode-time` uses `(os/clock)` for millisecond wall-clock precision.
  Do **not** replace it with `(os/time)` — that returns only integer
  seconds, so the millisecond portion of every generated ULID would
  be zero.
- `encode-random` consumes 16 bytes from `os/cryptorand` and uses the
  low 5 bits of each to pick a Crockford character. This gives the
  required 80 bits of entropy; the upper 3 bits of each byte are
  discarded. Correct but wasteful — fine at this scale.
- There is no monotonic-within-millisecond behaviour. If you add it,
  keep it opt-in so `new` stays a pure function of time + entropy.
