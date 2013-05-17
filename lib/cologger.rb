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

  attr_accessor :log_level

  # Set alias for const methods, to override the behavior
  class << self
    alias :old_const_get :const_get
    alias :old_const_set :const_set
  end

  # public methods
  def initialize
    @log_level = LEVEL_DEBUG # default to log everything
  end

  # Pass in a hash that contains the LEVEL to color hash
  def update_colors color_hash
    color_hash.each_pair do |sym, color|
      if respond_to? sym.to_sym
        if String::COLORS.has_key? color
          Cologger.const_set((sym_for sym.to_sym, "COLOR"), color)
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

  def self.const_get const, inherit=true
    if const =~ /COLOR_(.+)/
      level = $1.downcase.to_sym
      @@color_hash[level]
    else
      self.old_const_get const, inherit
    end
  end

  def self.const_set const, value
    if const =~ /COLOR_(.+)/
      level = $1.downcase.to_sym
      @@color_hash[level] = value
    else
      self.old_const_set const, value
    end
  end

  private
  @@color_hash = {
    fatal: "red",
    error: "magenta",
    warn:  "yellow",
    info:  "green",
    debug: "cyan"
  }

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
    return log
  end

end
