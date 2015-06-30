require 'set'

class Word
  attr_accessor :references

  @@count  = 0
  @@all    = []

  def self.count
    @@count
  end

  def self.all
    @@all
  end

  def self.active
    @@all.select { |w| w.references > 0 }
  end

  def initialize
    @@count += 1
    @references = 0
    @id = @@count
    @@all << self
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

    puts Word.all.map { |w| [w.id, w.references] }.to_s
    # @iterations += 1
    # num_words = self.all_words.size
    # if num_words > @max_words
    #   @max_words = num_words
    #   @time_to_max_words = @iterations
    # end
  end

  def report_results
    {
      words:       Word.count,
      iterations:  @iterations,
      convergence: self.all_words.to_a.first
    }
  end
end

# Benchmark.bm { |x| x.report { Game.run } }
Game.run 10
