class Game
  attr_accessor :players, :iterations

  def initialize(network)
    @network           = network
    @iterations        = 0
    @max_words         = 0
    @num_words         = 0
    @time_to_max_words = 0

    initialize_players
  end

  def initialize_players
    Player.reset
    @players = []
    @network.size.times do
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
    p, q = pick_players
    p.speak_to q

    @iterations += 1
    @active_words = Word.active.count
    # puts Word.active.map { |x| x.references }.to_s if @active_words < 6

    if @active_words > @max_words
      @max_words         = @active_words
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
    listener_id = @network.pick_neighbor_of(speaker_id)
    # puts [speaker_id, listener_id].to_s
    [@players[speaker_id], @players[listener_id]]
  end
end
