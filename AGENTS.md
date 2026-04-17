# Agent Instructions

## Language & Style

- Use Australian/British English.

## Repository Layout

This is a single-file Ruby gem. The entire implementation is in `lib/threadpuddle.rb`
and the sole test file is `test/test_threadpuddle.rb`. There are no subdirectories
within `lib/` or `test/`.

## Building & Testing

```
bundle install
rake test
```

The default Rake task is `test`. Tests use `test-unit` (not minitest, not RSpec).

## Gem Metadata

Version, file list, and other gem metadata live in `threadpuddle.gemspec` (not in a
version file or constant).

## Licence

ISC. The licence text is embedded in `lib/threadpuddle.rb` as a `=begin`/`=end` block
at the end of the file. Preserve it there.
