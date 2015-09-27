# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'qt-deploy-win/version'

Gem::Specification.new do |spec|
  spec.name          = "qt-deploy-win"
  spec.version       = QtDeployWin::VERSION
  spec.authors       = ["MOZGIII"]
  spec.email         = ["mike-n@narod.ru"]
  spec.description   = %q{This gem provides a small command to gather all application files required for a Qt app deploy for Windows in one place ready for packaging.}
  spec.summary       = %q{Win at deplying Qt applications for Windows}
  spec.homepage      = "https://github.com/MOZGIII/qt-deploy-win"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency "visual_studio", "0.0.0.3"
end
