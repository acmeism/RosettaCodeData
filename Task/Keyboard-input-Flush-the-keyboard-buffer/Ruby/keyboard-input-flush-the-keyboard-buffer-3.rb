class IO
  def discard_input
    icanon = false
    if tty?
      begin
        # With Ruby 1.9.3, simply call IO#iflush.
        require 'io/console'
        return iflush
      rescue LoadError
        # Try to run stty(1) to check if this terminal uses
        # canonical input mode. Acts like `stty -a`, but redirects
        # stdin from tty. Works with Ruby 1.8, no Process#spawn.
        r, w, pid = nil
        begin
          r, w = IO.pipe
          pid = fork do
            IO.for_fd(0).reopen(self)  # stdin from tty
            IO.for_fd(1).reopen(w)     # stdout to pipe
            exec 'stty', '-a'
          end
          w.close; w = nil
          icanon = (not r.read.include? "-icanon")
        rescue
          # stty(1) only works with Unix clones.
        ensure
          pid and Process.wait pid
          w and w.close
          r and r.close
        end
      end
    end

    if icanon
      # Turn off canonical input mode.
      pid = nil
      begin
        pid = fork do
          IO.for_fd(0).reopen(self)  # stdin from tty
          exec 'stty', '-icanon'
        end
      ensure
        pid and Process.wait pid
      end
    end

    # Discard input.
    loop { $stdin.read_nonblock(256) } rescue nil

    if icanon
      # Turn on canonical input mode.
      pid = nil
      begin
        pid = fork do
          IO.for_fd(0).reopen(self)  # stdin from tty
          exec 'stty', 'icanon'
        end
      ensure
        pid and Process.wait pid
      end
    end

    nil
  end
end
