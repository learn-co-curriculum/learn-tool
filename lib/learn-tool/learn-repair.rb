class LearnRepair < LearnBase

    def initialize(filepath)
      super(filepath)
      cd_into_and(filepath, create_learn_file)
      cd_into_and(filepath, create_support_file("LICENSE.md"))
      cd_into_and(filepath, create_support_file("CONTRIBUTING.md"))
    end

    def create_learn_file
      'echo "languages:" > .learn && echo "  - none" >> .learn'
    end

    def create_support_file(name_of_file)
      # copies a template folder from the learn_create gem to a subfolder of the current directory
      gem_template_location = File.dirname(__FILE__)
      template_path = File.expand_path(gem_template_location) + "/support_files/#{name_of_file}"
      "cp #{template_path} #{@filepath}"
    end
    
end