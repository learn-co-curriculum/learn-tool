require 'faraday'
require 'uri'
require 'open3'

class LearnTool
  GITHUB_ORG = 'https://api.github.com/repos/learn-co-curriculum/'
  README_TEMPLATE = 'readme-template'
  RUBY_LAB_TEMPLATE = 'ruby-lab-template'
  JAVASCRIPT_LAB_TEMPLATE = 'js-lab-template'
  REACT_LAB_TEMPLATE = 'react-lab-template'

  def initialize(mode)
    @ssh_configured  = check_ssh_config
    puts mode
    if mode == 'create'
      create
    end

    if mode == 'duplicate'
      duplicate
    end

    if mode == 'repair'
      repair
    end
  end

  def create
    puts 'Note: You must have write access to the learn-co-curriculum org on GitHub to use this tool'
    until name_new_repo do
      puts 'Careful - rate limiting can occur'
    end

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

  def duplicate
    puts 'Note: You must have write access to the learn-co-curriculum org on GitHub to use this tool'
    loop do
      puts 'What is the name of the repository you would like to copy? Paste exactly as is shown in the URL (i.e. advanced-hashes-hashketball)'
      old_repo_name_input = gets.strip
      if repo_exists(old_repo_name_input)
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

  def name_new_repo
    puts 'What is the name of the repository you would like to create?'
    new_name = gets.strip.gsub(/\s+/, '-').downcase

    if name_length_is_good(new_name)
      if !repo_exists(new_name)
        @new_repo_name = new_name
      else
        puts 'A repository with that name already exists. Please try again.'
        return false
      end
    else
      puts 'Repository names must be shorter than 100 characters'
      return false
    end
    @new_repo_name
  end

  def create_new_repo
    # 'cd' doesn't work the way it would in the shell, must be used before every command
    puts 'Cloning old repository'
    git_clone
    # puts "Renaming old directory with new name: #{@new_repo_name}"
    # rename_repo
    puts ''
    puts 'Creating new remote learn-co-curriculum repository'
    git_create_and_set_new_origin
    puts ''
    puts 'Setting new git remote based on SSH settings'
    git_set_remote
    puts ''
    puts 'Pushing all old-remote branches to new remote'
    git_push
  end

  def end_message
    puts ''
    puts 'To access local folder, change directory into ' + @new_repo_name + '/'
    puts "Repository available at #{GITHUB_ORG}" + @new_repo_name
  end

  private

  def git_clone
    cmd = "git clone https://github.com/learn-co-curriculum/#{@old_repo_name} #{@new_repo_name}"
    puts cmd
    `#{cmd}`
  end

  def git_create_and_set_new_origin
    # Creates repo **and** assigns new remote to 'origin' shortname
    cmd = cd_into_and("hub create learn-co-curriculum/#{@new_repo_name}")
    puts cmd
    `#{cmd}`
  end

  def git_set_remote
    remote = check_ssh_config ? "git@github.com:learn-co-curriculum/#{@new_repo_name}.git" : "https://github.com/learn-co-curriculum/#{@new_repo_name}"
    cmd = cd_into_and("git remote set-url origin #{remote}")
    puts cmd
    `#{cmd}`
  end

  def git_push
    # Copy `master`, attempt to copy `solution`, but if it's not there, no complaints
    cmds = [
      %q|git push origin 'refs/remotes/origin/master:refs/heads/master' > /dev/null 2>&1|,
      %q|git push origin 'refs/remotes/origin/solution:refs/heads/solution' > /dev/null 2>&1|
    ]
    cmds.each { |cmd| `#{cd_into_and(cmd)}` }
  end

  def repo_exists(repo_name)
    url = GITHUB_ORG + repo_name
    encoded_url = URI.encode(url).slice(0, url.length)
    check_existing = Faraday.get URI.parse(encoded_url)
    !check_existing.body.include? '"Not Found"'
  end

  def cd_into_and(command)
    "cd #{@new_repo_name} && #{command}"
  end

  def create_support_file(name_of_file)
    # copies a template folder from the learn_create gem to a subfolder of the current directory
    gem_template_location = File.dirname(__FILE__)
    template_path = File.expand_path(gem_template_location) + "/support_files/#{name_of_file.upcase}"
    cmd = "cp #{template_path} #{Dir.pwd}"
    `#{cmd}`
  end

  def create_dot_learn_file
    `
cat > .learn <<EOL
languages:
- none
    `
  end
  
#   def create_dot_gitignore_file
#     `
# cat > .gitignore <<EOL
# .DS_Store
# logs
# *.log
# npm-debug.log*
# pids
# *.pid
# *.seed
# lib-cov
# build/Release
# node_modules
# jspm_packages
# .npm
# .node_repl_history
# .results.json
# /.bundle
# /db/*.sqlite3
# /db/*.sqlite3-journal
# /log/*
# !/log/.keep
# /tmp
#     `
#   end

  

  def repair
    create_dot_learn_file
    create_support_file("LICENSE.md")
    create_support_file("CONTRIBUTING.md")
  end

  def name_length_is_good(name)
    name.length < 100
  end

  def check_ssh_config
    result = Open3.capture2e('ssh -T git@github.com').first
    result.include?("You've successfully authenticated")
  end

  
end