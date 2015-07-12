class NumericWord < Word
  AGREEMENT_THRESHOLD = 10
  MAX_VALUE = 200

  class << self
    def find_or_create(value)
      Word.by_value[value] || NumericWord.new(value)

      # if Word.by_value.has_key? value
      #   Word.by_value[value]
      # else
      #   NumericWord.new(value)
      # end
    end

    protected
    def new(*args)
      super *args
    end
  end

  def initialize(value)
    @id = Word.count
    @references = 0
    @value = value
    Word.count += 1
    Word.all << self
    Word.by_value[value] = self
  end

end