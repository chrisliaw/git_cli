require_relative 'lib/git_cli/version'

Gem::Specification.new do |spec|
  spec.name          = "git_cli"
  spec.version       = GitCli::VERSION
  spec.authors       = ["Chris Liaw"]
  spec.email         = ["chrisliaw@antrapol.com"]

  spec.summary       = %q{GIT command line interface}
  spec.description   = %q{Interface to GIT via command line interface instead of some sor of library}
  spec.homepage      = "https://github.com/chrisliaw/git_cli"
  spec.license       = "GPL-3.0"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  #spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  #spec.metadata["homepage_uri"] = spec.homepage
  #spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  #spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  #spec.add_dependency "tlogger"
  spec.add_dependency 'teLogger'
  spec.add_dependency "toolrack"
  spec.add_dependency "gvcs" 
  spec.add_dependency "ptools", "~> 1.4.0"

  #spec.add_development_dependency 'devops_helper' #, ">= 0.2.0"
  spec.add_development_dependency 'devops_assist' #, ">= 0.2.0"
  spec.add_development_dependency 'gem-release'
  spec.add_development_dependency 'release-gem'
end
