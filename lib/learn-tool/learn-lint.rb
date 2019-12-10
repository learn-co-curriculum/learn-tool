class LearnLinter
    def initialize(filepath)
        @learn_error = LearnError.new
        @filepath = filepath
    end

    def result_message
      @learn_error.result_message
    end
  
    def has_file?(file)
      Dir.entries(@filepath).include?(file) || Dir.entries(@filepath).include?(file.upcase) || Dir.entries(@filepath).include?(file.downcase)
    end

    def lint_directory
      self.yaml_lint
      self.license_lint
      self.readme_lint
      self.contributing_lint
      @learn_error.result_output
      @learn_error.total_errors
    end

    def yaml_lint
      if self.has_file?(".learn")
        @learn_error.yaml_error[:present_dotlearn] = true
        @learn_error.present_learn = {message: "present .learn file", color: :green}
        YamlLint.parse_file("#{@filepath}/.learn", @learn_error)
      end
    end
  
    def license_lint
      if self.has_file?("LICENSE.md")
        @learn_error.license_error[:present_license] = true
        @learn_error.present_license = {message: "present LICENSE.md", color: :green}
        LicenseLinter.parse_file("#{@filepath}/LICENSE.md", @learn_error)
      end
    end
  
    def readme_lint
      if self.has_file?("README.md")
        @learn_error.readme_error[:present_readme] = true
        @learn_error.present_readme = {message: "present README.md", color: :green}
        ReadmeLinter.parse_file("#{@filepath}/README.md", @learn_error)
      end
    end
  
    def contributing_lint
      if self.has_file?("CONTRIBUTING.md")
        @learn_error.contributing_error[:present_contributing] = true
        @learn_error.present_contributing = {message: "present CONTRIBUTING.md", color: :green}
        ContributingLinter.parse_file("#{@filepath}/CONTRIBUTING.md", @learn_error)
      end
    end
end