MRuby::Gem::Specification.new('mruby-msgpack-rpc') do |spec|
  spec.license = 'MIT'
  spec.author  = 'mattn'
  spec.add_dependency('mruby-msgpack')
  spec.add_dependency('mruby-socket')
end
