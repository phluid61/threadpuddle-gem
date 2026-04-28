ThreadPuddle
============

[![Gem Version](https://badge.fury.io/rb/threadpuddle.png)](http://badge.fury.io/rb/threadpuddle)
[![Test](https://github.com/phluid61/threadpuddle-gem/actions/workflows/test.yml/badge.svg)](https://github.com/phluid61/threadpuddle-gem/actions/workflows/test.yml)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v3.0%20adopted-ff69b4.svg)](code_of_conduct.md)

Like a smaller, lamer thread pool.

----

## Public Class Methods

### `ThreadPuddle.new(capacity, klass=Thread)`
Creates a new ThreadPuddle object, with a fixed capacity.

To use with a different threading model, specify a different `klass`, for example:

```ruby
tp = ThreadPuddle.new c, ForkingThread
```

## Public Instance Methods

### `tp.capacity` → int
Retrieves the ThreadPuddle object's capacity.

### `tp.size` → int
Number of threads currently occupying the puddle.

### `tp.block` → _tp_
Blocks execution of the calling thread until there's a free slot in the puddle.

WARNING: there is no guarantee this will ever return.

### `tp.spawn(*args) {|*args| ... }` → Thread
Spawns a new thread in the puddle.

If the puddle is full, this call blocks.

```
 @yields *args
 @see ThreadPuddle#block
 @return the new Thread object
```

### `tp.join` → _tp_
Waits for all threads in the puddle to join.

```
 @return this ThreadPuddle object
```

### `tp.kill` → int
Kills all threads in the puddle.

```
 @return the number of threads killed
```

----

[![Test](https://github.com/phluid61/threadpuddle-gem/actions/workflows/test.yml/badge.svg)](https://github.com/phluid61/threadpuddle-gem/actions/workflows/test.yml)

