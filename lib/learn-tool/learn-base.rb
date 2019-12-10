require 'pry'
class LearnBase

  GITHUB_ORG = 'https://api.github.com/repos/learn-co-curriculum/'
  README_TEMPLATE = 'readme-template'
  RUBY_LAB_TEMPLATE = 'ruby-lab-template'
  JAVASCRIPT_LAB_TEMPLATE = 'js-lab-template'
  REACT_LAB_TEMPLATE = 'react-lab-template'

  def initialize(filepath)
    @filepath = filepath
    @old_repo_name = ''
    @new_repo_name = ''
  end

  def repo_is_available(repo_name)
    url = GITHUB_ORG + repo_name
    encoded_url = URI.encode(url).slice(0, url.length)
    check_existing = Faraday.get URI.parse(encoded_url)
    check_existing.body.include? '"Not Found"'
  end

  def cd_into_and(filepath, command)
    cmd = "cd #{filepath} && #{command}"
    `#{cmd}`
  end

  def name_new_repo
    puts 'What is the name of the repository you would like to create?'
    new_name = gets.strip.gsub(/\s+/, '-').downcase

    if name_length_is_good(new_name)
      if repo_is_available(new_name)
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

  def get_new_name
    puts 'Note: You must have write access to the learn-co-curriculum org on GitHub to use this tool'
    until name_new_repo do
      puts 'Careful - rate limiting can occur'
    end
  end

  def create_new_repo
    # 'cd' doesn't work the way it would in the shell, must be used before every command
    puts 'Cloning old repository'
    git_clone
    # puts "Renaming old directory with new name: #{new_repo_name}"
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
    cd_into_and(@filepath + "/#{@new_repo_name}", "hub create learn-co-curriculum/#{@new_repo_name}")
  end

  def git_set_remote
    remote = check_ssh_config ? "git@github.com:learn-co-curriculum/#{@new_repo_name}.git" : "https://github.com/learn-co-curriculum/#{new_repo_name}"
    cd_into_and(@filepath + "/#{@new_repo_name}", "git remote set-url origin #{remote}")
  end

  def git_push
    # Copy `master`, attempt to copy `solution`, but if it's not there, no complaints
    cmds = [
      %q|git push origin 'refs/remotes/origin/master:refs/heads/master' > /dev/null 2>&1|,
      %q|git push origin 'refs/remotes/origin/solution:refs/heads/solution' > /dev/null 2>&1|
    ]
    cmds.each { |cmd| cd_into_and(@filepath + "/#{@new_repo_name}", cmd) }
  end

  def name_length_is_good(name)
    name.length < 100
  end

  def check_ssh_config
    result = Open3.capture2e('ssh -T git@github.com').first
    result.include?("You've successfully authenticated")
  end
end