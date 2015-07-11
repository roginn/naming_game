class Game
  attr_accessor :players, :iteration, :metrics

  def initialize(network)
    @metrics           = Metrics.new(self)
    @network           = network
    @iteration         = 0

    initialize_players
  end

  def initialize_players
    Player.reset
    @players = []
    @network.size.times do
      @players << Player.new
      # @players << NumericPlayer.new
    end
  end

  def all_words
    @players.map { |x| x.words }.flatten.to_set
  end

  def stop_condition?
    @metrics.active_words == 1 and Word.active.first.references == @players.size
  end

  def debug_players
    @players.each do |player|
      puts "player: #{player.id}"
      puts player.words.map { |w| w.value }.to_s
    end
  end

  def debug_words
    values = Word.active.map { |w| w.value }
    puts values.inject(:+) / values.size
  end

  def iterate
    p, q = pick_players
    outcome = p.speak_to q

    @iteration += 1
    @metrics.update! outcome
    # puts Word.active.map { |x| x.references }.to_s if @active_words < 6
    # puts Word.active.map { |x| x.value }.to_s
    # debug_players
    # debug_words

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
      max_words:   @metrics.max_words,
      iterations:  @iteration,
      convergence: self.all_words.to_a.first,
      time_to_max_words: @metrics.time_to_max_words,
      different_words: @metrics.different_words,
      total_words: @metrics.total_words,
      successes: @metrics.successes
    }
  end

  protected
  def pick_players
    speaker_id = @network.pick_player
    listener_id = @network.pick_neighbor_of(speaker_id)
    # puts [speaker_id, listener_id].to_s
    [@players[speaker_id], @players[listener_id]]
  end
end
