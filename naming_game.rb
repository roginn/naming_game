require 'set'

class Word
  @@count = 0
  def self.count
    @@count
  end

  def self.get_new_one
    @@count += 1
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
      @words << Word.get_new_one
    end

    @words.sample
  end

  def has_word?(w)
    @words.include? w
  end

  def drop_all_but(w)
    @words = [w]
  end

  def add_word(w)
    @words << w
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

  class << self
    def run(n = 100)
      game = Game.new n
      until game.stop_condition?
        game.iterate
      end
      game.report_results
    end
  end

  def initialize(n = 100)
    @players    = []
    @iterations = 0
    @max_words  = 0
    @time_to_max_words = 0

    (1..n).each do |i|
      @players << Player.new
    end
  end

  def all_words
    @players.map { |x| x.words }.flatten.to_set
  end

  def stop_condition?
    @players.map { |x| x.words.size == 1 }.all? and self.all_words.size == 1
    # @players.map { |x| x.words.size == 1 }.all? and @num_words == 1
  end

  def iterate
    p = @players.sample
    q = (@players - [p]).sample
    p.speak_to q

    @iterations += 1
    num_words = self.all_words.size
    if num_words > @max_words
      @max_words = num_words
      @time_to_max_words = @iterations
    end
  end

  def report_results
    {
      words:       Word.count,
      iterations:  @iterations,
      convergence: self.all_words.to_a.first
    }
  end
end

Benchmark.bm { |x| x.report { Game.run 1000 } }
