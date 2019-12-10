class LearnCreate < LearnBase

    def initialize(filepath)
      super(filepath)
      get_new_name
      choose_repo_template
      create_new_repo
      end_message
    end

    def choose_repo_template
      puts 'Is the lesson you are creating a Readme? (Y/n)'
      readme_input = gets.chomp.downcase
      if readme_input == "n" || readme_input == "no" || readme_input == "N" || readme_input == "No"
        language = choose_language
        case language
        when /^ru/
          @old_repo_name = RUBY_LAB_TEMPLATE
        when /^j/
          @old_repo_name = JAVASCRIPT_LAB_TEMPLATE
        when /^re/
          @old_repo_name = REACT_LAB_TEMPLATE
        else
          @old_repo_name = README_TEMPLATE
        end
      else
        @old_repo_name = README_TEMPLATE
      end
      @old_repo_name
    end
  
    def choose_language
      language = ''
      loop do
        puts 'What lab template would you like to use? (Ruby/JavaScript/React)'
        language = gets.chomp.downcase
        break if language =~ /^(ru|j|re)/
        puts 'Please enter Ruby, JavaScript or React, or at minimum, the first two letters:'
        puts ''
      end
      language
    end

end