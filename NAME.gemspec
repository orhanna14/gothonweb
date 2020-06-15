# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "NAME"
  spec.version       = '1.0'
  spec.authors       = ["Olivia"]
  spec.email         = ["oliviamcgoffin@gmail.com"]
  spec.summary       = %q{Make a simple 'hello world' project}
  spec.description   = %q{Using sinatra and the skeleton from ex46}
  spec.homepage      = "http://domainforproject.com/"
  spec.license       = "MIT"

  spec.files         = ['lib/NAME.rb']
  spec.executables   = ['bin/NAME']
  spec.test_files    = ['spec/NAME_spec.rb']
  spec.require_paths = ["lib"]
end