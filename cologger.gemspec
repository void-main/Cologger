Gem::Specification.new do |s|
  s.name              = "cologger"
  s.version           = "0.1.3"
  s.date              = "2013-05-14"
  s.summary           = "Log with color!"
  s.homepage          = "http://github.com/void-main/Cologger"
  s.email             = "voidmain1313113@gmail.com"
  s.authors           = ["Peng Sun"]
  s.has_rdoc          = true
  s.extra_rdoc_files  = ['README.md']
  s.require_path      = "lib"
  s.files             = %w( README.md LICENSE )
  s.files            += Dir.glob("lib/**/*")
  s.add_runtime_dependency 'colored', '~> 1.2'
  s.description       = <<-desc
  Simple log util that adds some colors to your logs.

  For more information, please visit 'https://github.com/void-main/Cologger'
  desc
end
