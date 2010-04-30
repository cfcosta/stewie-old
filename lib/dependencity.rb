# encoding: utf-8

class Dependencity
  def initialize
    @directories = []
    @ignore_list = []
    @patterns = []
  end

  def ignore(name)
    @ignore_list << name
  end

  def add_dir(name)
    @directories << name
  end

  def add_rule(name)
    @patterns << name
  end

  def get_files(directory)
    @files = Dir.glob(directory + "/" + File.join("**","*.rb")).sort
    return @files
  end

  def move_to_front(value)
    filename = @files[value]
    @files.delete_at(value)
    @files.unshift(filename)
  end

  def process_rules(files)
    go_down = @patterns.length()
    step = @patterns.length() - 1
    go_down.times do |rule|
      counter = 0
      files.each do |file|
        if file.match(@patterns[step])
          files = move_to_front(counter)
        end
        counter += 1
      end
      step -= 1
    end
    return files
  end

  def require_all(files)
    files.each do |file|
      action = true
      @ignore_list.each do |ignore|
        if file == ignore
          action = false
        end
      end
      if action == true
        require file
        puts"Loaded file: #{file}"
      end
    end
  end

  def load_directory directory
    files = get_files(directory)
    files = process_rules(files)
    require_all(files)
  end

  def process_directories
    @directories.each do |directory|
      load_directory(directory)
    end
  end
end
