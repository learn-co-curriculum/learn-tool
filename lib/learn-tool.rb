require 'faraday'
require 'uri'
require 'open3'
require_relative './learn-tool/learn-base'
require_relative './learn-tool/learn-repair'
require_relative './learn-tool/learn-create'
require_relative './learn-tool/learn-duplicate'
require_relative './learn-tool/learn-lint'
require_relative './learn-tool/learn-error'
require_relative './learn-tool/license-linter'
require_relative './learn-tool/readme-linter'
require_relative './learn-tool/yaml-linter'
require_relative './learn-tool/contributing-linter'

class LearnTool
  

  def initialize(mode:, filepath:Dir.pwd)
    puts filepath
    if mode == 'create'
      LearnCreate.new(filepath)
    end

    if mode == 'duplicate'
      LearnDuplicate.new(filepath)
    end

    if mode == 'repair'
      LearnRepair.new(filepath)
    end

    if mode == 'lint'
      LearnLinter.new(filepath).lint_directory
    end
  end

 

  

  

  

  

  

  
end