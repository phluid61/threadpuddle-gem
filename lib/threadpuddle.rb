
#
# Like a smaller, lamer thread pool.
#
class ThreadPuddle
  def initialize capacity
    @capacity = capacity
    @threads = []
  end

  attr_reader :capacity

  #
  # Blocks execution of the calling thread until there's a free
  # slot in the puddle.
  #
  # WARNING: there is no guarantee this will ever return.
  #
  def block
    loop {
      return self if @threads.length < @capacity
      if @threads.any?{|t| t.join(0) }
        sweep
      end
    }
  end

  #
  # Number of threads currently occupying the puddle.
  #
  def size
    sweep
    @threads.length
  end

  #
  # Spawns a new thread in the puddle.
  #
  # If the puddle is full, this call blocks.
  #
  # @see ThreadPuddle#block
  # @return the new Thread object
  #
  def spawn *args, &blk #:yields: *args
    # wait for a slot to open
    block
    # add the new thread
    @threads << (t = Thread.new(*args, &blk))
    t
  end

  #
  # Waits for all threads in the puddle to join.
  #
  # @return this ThreadPuddle object
  #
  def join
    while @threads.any?
      sweep
      @threads.each{|t| t.join rescue nil }
    end
    self
  end

  #
  # Kills all threads in the puddle.
  #
  # @return the number of threads killed
  #
  def kill
    l = @threads.each{|t| t.kill rescue nil }.length
    sweep
    l
  end

private

  # sweep the puddle, delete dead threads
  def sweep #:nodoc:
    @threads.delete_if {|t| ! t.alive? }
  end

end

=begin
Copyright (c) 2013, Matthew Kerwin <matthew@kerwin.net.au>

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
=end

