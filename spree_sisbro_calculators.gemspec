Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_git@github.com:_calculators'
  s.version     = '0.1.1'
  s.summary     = 'Sisbro calculators for spree'
  s.description = 'Allows to calculate shipping costs based on total item weigh and quantity in the order'
  s.required_ruby_version = '>= 1.8.7'

  s.author            = 'Jurgis Jurksta'
  s.email             = 'jurgis@emails.lv'
  s.homepage          = 'https://github.com/jurgis/spree-git@github.com:-calculators'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency('spree_core', '>= 0.50.2')
end
