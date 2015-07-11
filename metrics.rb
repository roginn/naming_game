class Metrics
  attr_reader :total_words, :different_words, :successes, :active_words, :max_words, :time_to_max_words

  def initialize(game)
    @game              = game
    @total_words       = []
    @different_words   = []
    @successes         = []
    @max_words         = 0
    @time_to_max_words = 0
  end

  def update!(outcome)
    iteration = @game.iteration
    @active_words = Word.active.count

    if @active_words > @max_words
      @max_words     = @active_words
      @time_to_max_words = iteration
    end

    @different_words[iteration - 1] = @active_words
    @total_words[iteration - 1] = @game.players.map { |p| p.words.size }.inject(:+)
    @successes[iteration - 1] = @successes.last.to_i + (outcome ? 1 : 0)
  end

  def successes
    max_successes = @successes.max
    @successes.map { |s| s.to_f / max_successes }
  end
end
