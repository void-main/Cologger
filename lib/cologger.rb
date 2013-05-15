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

  def update_colors color_hash
    color_hash.each_pair do |sym, color|
      if respond_to? sym.to_sym
        if String::COLORS.has_key? color
          Cologger.const_set((sym_for sym.to_sym, "COLOR"), new_color)
          puts Cologger.const_get(sym_for sym.to_sym, "COLOR")
        else
          puts "Unknown color #{color} for #{sym}, ignord".red
        end
      else
        puts "Unknown log level #{sym}, ignored".red
      end
    end
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

    content = args.join(" ")
    log  = "#{sym_for method}\t"
    log += "[#{DateTime.now.iso8601}] "
    log += "#{content}"

    puts log.send(color) # TODO fixme!
  end

end
