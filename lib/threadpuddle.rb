#
# Like a smaller, lamer thread pool.
#
class ThreadPuddle
  def initialize capacity=10
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
  # Current size of the puddle.
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
  def spawn *args, &blk
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

