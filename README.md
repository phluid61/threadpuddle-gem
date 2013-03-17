ThreadPuddle
============

Like a smaller, lamer thread pool.

----

## Public Class Methods

### `ThreadPuddle.new(capacity)`
Creates a new ThreadPuddle object, with a fixed capacity.

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

[![Build Status](https://travis-ci.org/phluid61/threadpuddle-gem.png)](https://travis-ci.org/phluid61/threadpuddle-gem)
