module OperatingSystem
  require 'rbconfig'
  module_function
  def operating_system
    case RbConfig::CONFIG["host_os"]
    when /linux/i
      :linux
    when /cygwin|mswin|mingw|windows/i
      :windows
    when /darwin/i
      :mac
    when /solaris/i
      :solaris
    else
      nil
    end
  end
  def linux?;   operating_system == :linux;   end
  def windows?; operating_system == :windows; end
  def mac?;     operating_system == :mac;     end
end
