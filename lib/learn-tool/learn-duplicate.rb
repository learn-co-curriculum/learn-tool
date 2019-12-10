class LearnDuplicate < LearnBase

  def initialize(filepath)
    super(filepath)
    puts 'Note: You must have write access to the learn-co-curriculum org on GitHub to use this tool'
    get_old_repo
  end

  def get_old_repo  
    loop do
      puts 'What is the name of the repository you would like to copy? Paste exactly as is shown in the URL (i.e. advanced-hashes-hashketball)'
      old_repo_name_input = gets.strip
      if !repo_is_available(old_repo_name_input)
        @old_repo_name = old_repo_name_input
        puts ''
        puts 'Old repository: ' + @old_repo_name
        until name_new_repo do
          puts 'Careful - rate limiting can occur'
        end
        
        
        create_new_repo
        end_message
        break
      else
        puts 'Provided repository name is not a valid learn-co-curriculum repository. Please try again. Careful - rate limiting can be triggered'
      end
    end
  end

end