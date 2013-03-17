require 'test/unit'

$VERBOSE = true
require "#{File.dirname File.dirname(__FILE__)}/lib/threadpuddle"
class Test_threadpuddle < Test::Unit::TestCase
  def test_threadpuddle
    # Creation and attributes
    c = 5
    n = 2
    m = 7
    tp = ThreadPuddle.new(c)
    assert_equal( c, tp.capacity )
    assert_equal( 0, tp.size )

    # Spawning
    assert_nothing_raised do
      n.times do
        tp.spawn() { sleep 2 }
      end
    end
    assert_equal( n, tp.size )

    # Joining
    assert_nothing_raised{ tp.join }
    assert_equal( c, tp.capacity )
    assert_equal( 0, tp.size )

    # Overspawning
    assert_nothing_raised do
	m.times do
	    tp.spawn() { sleep 2 }
	end
	tp.join
    end

    # Return values
    obj = tp.spawn{}
    assert( obj.is_a?(Thread), "obj is_a #{obj.class}, should be Thread" )
    assert_equal( tp, tp.block )
    assert_equal( tp, tp.join )

    # Kill works
    n.times do
      tp.spawn() { sleep }
    end
    assert_nothing_raised{ tp.kill }
    tp.join
    assert_equal( 0, tp.size )

    # Kill returns the right number
    n.times do
      tp.spawn() { sleep }
    end
    assert_equal( n, tp.kill )
  end   
end

