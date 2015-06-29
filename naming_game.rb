class Word
  @@count = 0

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
  attr_reader words

  def speak_to(hearer)
    intersection = self.words & hearer.words
    if intersection.empty?
      
    else
      word = intersection.sample
      self.keep_only word
      hearer.keep_only word
    end
  end
end


