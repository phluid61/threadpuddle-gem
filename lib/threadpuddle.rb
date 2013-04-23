=begin
Copyright (c) 2013, Matthew Kerwin
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met: 

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer. 
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution. 

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
=end

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

