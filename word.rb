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

  attr_accessor :references, :id, :value

  def initialize(value = rand)
    @id = Word.count
    @references = 0
    @value = value
    Word.count += 1
    Word.all << self
    # puts "created word with value #{@value}"
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
