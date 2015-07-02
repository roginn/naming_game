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
    @id = Word.count
    @references = 0
    Word.count += 1
    Word.all << self
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
    Player.reset
    @players    = []
    @iterations = 0
    @max_words  = 0
    @num_words  = 0
    @time_to_max_words = 0
    @network = Network.new

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
    # p = @players.sample
    # q = (@players - [p]).sample
    p, q = pick_players
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

  protected
  def pick_players
    speaker_id = @network.pick_player
    listener_id = @network.pick_neighbor_from(speaker_id)
    puts speaker_id, listener_id
    [@players[speaker_id], @players[listener_id]]
  end
end

class Network
  attr_accessor :n, :p, :adjacency_list

  def initialize(n = 100, p = 0.05)
    @n = n
    @p = p
    make_adjacency_list
  end

  def pick_player
    rand(@n)
  end

  def pick_neighbor_from(node_id)
    @adjacency_list[node_id].sample
  end

  # protected
  def make_adjacency_list
    @adjacency_list = []

    (0 .. @n - 1).each do |node_id|
      @adjacency_list[node_id] ||= []

      (node_id + 1 .. @n - 1).each do |neighbor_id|
        next if node_id == neighbor_id
        if rand < @p
          @adjacency_list[neighbor_id] ||= []
          @adjacency_list[node_id] << neighbor_id
          @adjacency_list[neighbor_id] << node_id
          # puts "sucesso: #{node_id} e #{neighbor_id}"
          # puts "node: #{@adjacency_list[node_id].to_s}"
          # puts "neighbor: #{@adjacency_list[neighbor_id].to_s}"
        end
      end
    end
  end

  def is_connected?
    visited = [false] * @n
    stack = [0]

    until stack.empty?
      node = stack.pop
      visited[node] = true
      stack.push *@adjacency_list[node].select { |neighbor| !visited[neighbor] }
    end

    visited.all?
  end
end

# game = Game.new; game.run
Benchmark.bm { |x| x.report { game = Game.new; puts game.run } }


def experiment
  puts "network_size\titerations\tmax_words\titerations\tconvergence\ttime_to_max_words"
  (100..2000).step(100).each do |network_size|
    (1..30).each do |iteration|
      game = Game.new network_size;
      result = game.run;
      puts "#{network_size}\t#{iteration}\t#{result[:max_words]}\t#{result[:iterations]}\t#{result[:convergence].id}\t#{result[:time_to_max_words]}"
    end
  end
end
