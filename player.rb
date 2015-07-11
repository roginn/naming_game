class Player

  class << self
    attr_accessor :count

    def reset
      self.count = 0
    end
  end

  attr_accessor :id, :words

  def initialize
    @id = Player.count
    @words = []
    Player.count += 1
    # puts "created player"
  end

  def pick_random_word
    if @words.empty?
      self.add_word Word.new
    end

    @words.sample
  end

  def has_word?(w)
    @words.include? w
  end

  def drop_all_but(w)
    @words.each do |word|
      word.remove_reference unless word == w
    end
    @words = [w]
  end

  def drop_all
    @words.each do |word|
      word.remove_reference
    end
    @words = []
  end

  def add_word(w)
    @words << w
    w.add_reference
  end

  def speak_to(listener)
    w = self.pick_random_word
    if listener.has_word? w

      # success
      self.drop_all_but w
      listener.drop_all_but w
      true
    else

      # failure
      listener.add_word w
      false
    end
  end
end
