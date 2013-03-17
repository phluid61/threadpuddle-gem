ThreadPuddle
============

Like a smaller, lamer thread pool.

----

### `ThreadPuddle.new(capacity)`
Creates a new ThreadPuddle object, with a fixed capacity.

### `tp.capacity`
Retrieves the ThreadPuddle object's capacity.

### `tp.size`
Number of threads currently occupying the puddle.

### `tp.block`
Blocks execution of the calling thread until there's a free slot in the puddle.

WARNING: there is no guarantee this will ever return.

### `tp.spawn(\*args, &bk)`
Spawns a new thread in the puddle.

If the puddle is full, this call blocks.

 @yields \*args
 @see ThreadPuddle#block
 @return the new Thread object

### `tp.join`
Waits for all threads in the puddle to join.

 @return this ThreadPuddle object

### `tp.kill`
Kills all threads in the puddle.

 @return the number of threads killed

----

[![Build Status](https://travis-ci.org/phluid61/threadpuddle-gem.png)](https://travis-ci.org/phluid61/threadpuddle-gem)
