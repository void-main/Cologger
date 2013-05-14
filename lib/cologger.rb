require 'colored'
require 'date'

# Extending ruby's logger by adding some color in it!
#
class Cologger

  # an unhandleable error that results in a program crash
  LEVEL_FATAL = 0

  # a handleable error condition
  LEVEL_ERROR = 1

  # a warning
  LEVEL_WARN  = 2

  # generic (useful) information about system operation
  LEVEL_INFO  = 3

  # low-level information for developers
  LEVEL_DEBUG = 4

  # fatal in red
  COLOR_FATAL = 'red'

  # error in magenta
  COLOR_ERROR = 'magenta'

  # warn in yellow
  COLOR_WARN  = 'yellow'

  # info in green
  COLOR_INFO  = 'green'

  # debug in cyan
  COLOR_DEBUG = 'cyan'

  attr_accessor :log_level

  def initialize
    @log_level = LEVEL_DEBUG # default to log everything
  end

  def method_missing(method, *args, &block)
    if respond_to? method
      log(method, *args)
    end
  end

  def respond_to? (method, include_all=false)
    Cologger.constants.include? sym_for(method, "LEVEL")
  end

  private
  def sym_for method, prefix = nil
    str = "#{method.to_s.upcase}"
    str = "#{prefix}_#{str}" if prefix
    str.to_sym
  end

  def log(method, *args)
    level = Cologger.const_get(sym_for method, "LEVEL")
    color = Cologger.const_get(sym_for method, "COLOR")

    return unless level <= @log_level

    tag, *content_array = args
    content = content_array.join(" ")
    log  = "#{sym_for method}\t"
    log += "[#{DateTime.now.iso8601}] "
    log += "[#{tag}] #{content}"

    puts log.send(color) # TODO fixme!
  end

end
