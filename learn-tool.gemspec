Gem::Specification.new do |s|
    s.name = 'learn-tool'
    s.version = '0.0.16'
    s.date = '2019-12-10'
    s.authors = ['flatironschool']
    s.email = 'maxwell@flatironschool.com'
    s.license = 'MIT'
    s.summary = 'learn-tool is a tool for creating, duplicating and repairing learn.co lessons on GitHub'
    s.files = Dir.glob('{bin,lib}/**/*') + %w[LICENSE.md README.md CONTRIBUTING.md Rakefile Gemfile]
    s.require_paths = ['lib']
    s.homepage = 'https://github.com/learn-co-curriculum/learn-tool'
    s.executables << 'learn-tool'
    s.add_runtime_dependency 'faraday', '~> 0.15'
  end