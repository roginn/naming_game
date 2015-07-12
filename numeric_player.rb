class NumericPlayer < Player

  def closest_word_to(w)
    # @words.map { |z| (z.value - w.value).abs }.sort.first
    @words.sort_by { |z| (z.value - w.value).abs }.first
  end

  def pick_random_word
    if @words.empty?
      self.add_word NumericWord.find_or_create(rand(NumericWord::MAX_VALUE))
    end

    @words.sample
  end

  def speak_to(listener)
    w = self.pick_random_word
    z = listener.closest_word_to w

    # puts "w: #{w.value}; z: #{z.value unless z.nil?}"

    if z and (w.value - z.value).abs < NumericWord::AGREEMENT_THRESHOLD
      # puts "success! w: #{w.value} and z: #{z.value}"
      mean = ((w.value + z.value) / 2).ceil
      new_word = NumericWord.find_or_create mean
      self.drop_all
      listener.drop_all
      self.add_word new_word
      listener.add_word new_word  
      true
    else
      # puts "failure! w: #{w.value} and z nil" if z.nil?
      # puts "failure! w: #{w.value} and z: #{z.value}" unless z.nil?
      listener.add_word w
      false
    end
  end
end
