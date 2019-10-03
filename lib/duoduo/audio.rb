require 'open3'
require 'tmpdir'
require 'duoduo/piece'
require 'securerandom'
require 'fileutils'

# need: sox installed
class Duoduo::Audio
  def initialize(filepath, extension: 'mp3')
    @filepath = filepath
    @extension = extension
  end

  def pieces
    return @pieces if @pieces

    split!
    @pieces = []
    Dir.glob(File.join(sliced_dir, "*.#{@extension}")).sort.each do |filepath|
      @pieces << Duoduo::Piece.new(filepath)
    end
    @pieces
  end

  # private
  def split!
    Open3.capture3("sox #{@filepath} #{File.join(sliced_dir, basename)} silence -l 0 1 0.3 1% : newfile : restart")
  end

  def basename
    @basename ||= "#{File.basename(@filepath, '.*')}.#{@extension}"
  end

  def sliced_dir
    @sliced_dir ||= File.join(Dir.tmpdir, SecureRandom.hex).tap { |dir| FileUtils.mkdir_p(dir) }
  end
end
