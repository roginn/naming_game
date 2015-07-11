class NumericPlayer < Player

  def initialize
    @id = Player.count
    @words = []
    Player.count += 1
  end

  def closest_word_to(w)
    # @words.map { |z| (z.value - w.value).abs }.sort.first
    @words.sort_by { |z| (z.value - w.value).abs }.first
  end

  def speak_to(listener)
    w = self.pick_random_word
    z = listener.closest_word_to w

    # puts "w: #{w}; z: #{z}"

    if z and (w.value - z.value).abs < 0.1
      # puts "success! w: #{w.value} and z: #{z.value}"
      mean = (w.value + z.value) / 2
      new_word = Word.new mean
      self.drop_all
      listener.drop_all
      self.add_word new_word
      listener.add_word new_word  
    else
      # puts "failure! w: #{w.value} and z nil" if z.nil?
      # puts "failure! w: #{w.value} and z: #{z.value}" unless z.nil?
      listener.add_word w
    end
  end
end
