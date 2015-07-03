class LatticeNetwork < Network
  def initialize(n = 100, degree = 10)
    @size = n
    @degree = degree
    make_adjacency_list
  end

  # protected
  def make_adjacency_list
    @adjacency_list = []
    @size.times { @adjacency_list << [] }

    (0 .. @size - 1).each do |next_node|
      node_list = @adjacency_list[next_node]
      (1 .. @degree).each do |shift|
        neighbor = (next_node + shift) % @size
        neighbor_list = @adjacency_list[neighbor]
        node_list << neighbor unless node_list.include? neighbor
        neighbor_list << next_node unless neighbor_list.include? next_node
      end
    end    
  end
end
