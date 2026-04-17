require 'test/unit'

$VERBOSE = true
require "#{File.dirname File.dirname(__FILE__)}/lib/forkingthread"

class Test_forkingthread < Test::Unit::TestCase
  def setup
    @fts = []
    omit_unless Process.respond_to?(:fork), 'fork is not available on this platform'
  end

  def teardown
    @fts.each do |ft|
      ft.kill rescue nil
      ft.join rescue nil
    end
  end

  def new_ft(&blk)
    ft = ForkingThread.new(&blk)
    @fts << ft
    ft
  end

  # -- Lifecycle basics --

  def test_alive_when_running
    ft = new_ft { sleep }
    assert ft.alive?
  end

  def test_status_run_when_alive
    ft = new_ft { sleep }
    assert_equal "run", ft.status
  end

  def test_stop_false_when_alive
    ft = new_ft { sleep }
    assert_equal false, ft.stop?
  end

  def test_native_thread_id_is_integer_when_alive
    ft = new_ft { sleep }
    assert_kind_of Integer, ft.native_thread_id
  end

  def test_not_alive_after_exit
    ft = new_ft { }
    ft.join
    assert_equal false, ft.alive?
  end

  def test_stop_true_after_exit
    ft = new_ft { }
    ft.join
    assert_equal true, ft.stop?
  end

  def test_native_thread_id_nil_after_death
    ft = new_ft { }
    ft.join
    assert_nil ft.native_thread_id
  end

  # -- join --

  def test_join_returns_self
    ft = new_ft { }
    assert_equal ft, ft.join
  end

  def test_join_zero_on_running_returns_nil
    ft = new_ft { sleep }
    assert_nil ft.join(0)
  end

  def test_join_zero_on_finished_returns_self
    ft = new_ft { }
    sleep 0.1
    assert_equal ft, ft.join(0)
  end

  def test_join_timeout_expires_returns_nil
    ft = new_ft { sleep }
    assert_nil ft.join(0.1)
  end

  def test_join_is_idempotent
    ft = new_ft { }
    assert_equal ft, ft.join
    assert_equal ft, ft.join
  end

  # -- kill --

  def test_kill_returns_self
    ft = new_ft { sleep }
    assert_equal ft, ft.kill
  end

  def test_not_alive_after_kill
    ft = new_ft { sleep }
    ft.kill
    ft.join
    assert_equal false, ft.alive?
  end

  # -- status --

  def test_status_false_after_clean_exit
    ft = new_ft { }
    ft.join
    assert_equal false, ft.status
  end

  def test_status_nil_after_nonzero_exit
    ft = new_ft { exit! 1 }
    ft.join
    assert_nil ft.status
  end

  def test_status_nil_after_kill
    ft = new_ft { sleep }
    ft.kill
    ft.join
    assert_nil ft.status
  end

  # -- name --

  def test_name_defaults_to_nil
    ft = new_ft { sleep }
    assert_nil ft.name
  end

  def test_name_roundtrips
    ft = new_ft { sleep }
    ft.name = "worker-1"
    assert_equal "worker-1", ft.name
  end
end
