require 'set'
require 'benchmark'

class Word
  class << self
    attr_accessor :count, :all

    def active
      self.all.select { |w| w.references > 0 }
    end

    def reset
      self.count = 0
      self.all   = []
    end
  end

  attr_accessor :references, :id

  def initialize
    Word.count += 1
    Word.all << self
    @id = Word.count
    @references = 0
  end

  def ==(other)
    self.id == other.id
  end

  def add_reference
    @references += 1
  end

  def remove_reference
    @references -= 1
  end
end


class Node
  def neighbors
  end

  def random_neighbor
    neighbors.sample
  end
end

class Player
  attr_accessor :words

  def initialize
    @words = []
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
    else

      # failure
      listener.add_word w
    end
  end
end

class Game
  attr_accessor :players, :iterations

  def initialize(n = 100)
    @players    = []
    @iterations = 0
    @max_words  = 0
    @num_words  = 0
    @time_to_max_words = 0

    (1..n).each do |i|
      @players << Player.new
    end
  end

  def all_words
    @players.map { |x| x.words }.flatten.to_set
  end

  def stop_condition?
    @active_words == 1 and Word.active.first.references == @players.size
  end

  def iterate
    p = @players.sample
    q = (@players - [p]).sample
    p.speak_to q

    @iterations += 1
    @active_words = Word.active.count

    if @active_words > @max_words
      @max_words = @active_words
      @time_to_max_words = @iterations
    end
  end

  def run
    Word.reset
    until self.stop_condition?
      self.iterate
    end
    self.report_results
  end

  def report_results
    {
      max_words:   @max_words,
      iterations:  @iterations,
      convergence: self.all_words.to_a.first,
      time_to_max_words: @time_to_max_words
    }
  end
end

# game = Game.new; game.run
Benchmark.bm { |x| x.report { game = Game.new; puts game.run } }
