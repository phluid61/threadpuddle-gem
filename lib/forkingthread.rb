
require 'timeout'

#
# A wrapper for forked processes that imitates some of the
# Thread class's interface.
#
class ForkingThread
  def initialize *args, &blk
    warn "ForkingThread#new doesn't support args" unless args.empty?

    @pid = fork(&blk)
    @dead = false
    @status = nil
    @name = nil
  end

  attr_accessor :name

  def join limit=nil
    return self if @dead
    if limit.nil?
      # wait indefinitely
      result = Process.wait2(@pid, 0) rescue nil
    elsif limit > 0
      # wait for up to some number of seconds
      result = Timeout::timeout(limit) { Process.wait2(@pid, 0) } rescue nil
    else
      # return immediately
      result = Process.wait2(@pid, Process::WNOHANG) rescue nil
    end
    if result
      @dead = true
      @status = result[1]
      return self
    end
  end

  def kill
    Process.kill('KILL', @pid) rescue nil
    self
  end

  def alive?
    return false if @dead
    result = Process.wait2(@pid, Process::WNOHANG) rescue nil
    if result
      @dead = true
      @status = result[1]
      return false
    end
    true
  end

  def status
    alive? ? "run" : (@status&.success? ? false : nil)
  end

  def stop?
    !alive?
  end

  def native_thread_id
    alive? ? @pid : nil
  end
end

=begin
Copyright (c) 2026, Matthew Kerwin <matthew@kerwin.net.au>

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

