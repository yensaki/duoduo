require 'open3'

# need: sox installed
class Duoduo::Audio
  def initialize(filepath)
    @filepath = filepath
  end

  def pieces
    return @pieces if @pieces

    split!
    @pieces = []
    Dir.glob(File.join(sliced_dir, '*')).sort.each do |filepath|
      @pieces << Duoduo::Piece.new(filepath)
    end
  end

  # private
  def split!
    Open3.capture3("sox #{@filepath} #{File.join(sliced_dir, basename)} silence 1 0.3 1% 1 0.3 1% : newfile : restart")
  end

  def basename
    @basename ||= File.basename(@filepath)
  end

  def sliced_dir
    @sliced_dir ||= Dir.tmpdir
  end
end
