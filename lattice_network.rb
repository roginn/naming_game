class LatticeNetwork < Network
  def initialize(n = 100)
    @size = n
    make_adjacency_list
  end

  # protected
  def make_adjacency_list
    @adjacency_list = []
    @size.times { @adjacency_list << [] }
    degrees = [0] * @size

    m0 = 4

    (0 .. m0 - 1).each do |i|
      @adjacency_list[i].push *((0 .. m0 - 1).to_a - [i]).to_a
      degrees[i] = m0 - 1
    end

    connections = degrees.inject(:+)
    (3 .. @size - 1).each do |next_node|
      acc_roulette = degrees.inject([0]) { |acc, x| acc << acc.last + x; acc }.drop(1)
      r = rand(connections)
      chosen = nil
      acc_roulette.each_with_index do |e, i|
        if e > r
          chosen = i
          break
        end
      end

      @adjacency_list[chosen] << next_node
      @adjacency_list[next_node] << chosen
      degrees[chosen] += 1
      degrees[next_node] += 1
      connections += 2
    end
  end
end
