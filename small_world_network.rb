class SmallWorldNetwork < Network
  def initialize(n = 100, degree = 10, rewire_prob = 0.03)
    @size = n
    @degree = degree
    @rewire_prob = rewire_prob
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

    (0 .. @size - 1).each do |node|
      node_list = @adjacency_list[node]

      included_neighbors = []

      node_list.each do |neighbor|
        if rand < @rewire_prob
          next_neighbor = ((0 .. @size - 1).to_a - [node] - node_list).sample
            # puts "#{(0 .. @size - 1).to_a.to_s} - #{[node].to_a.to_s} - #{node_list.to_a.to_s}"
            # puts "next_neighbor: #{next_neighbor}"
          included_neighbors << next_neighbor unless included_neighbors.include? next_neighbor
          node_list.delete neighbor
          @adjacency_list[neighbor].delete node
        end
      end

      # puts included_neighbors.to_s

      included_neighbors.each do |new_neighbor|
        node_list << new_neighbor
        @adjacency_list[new_neighbor] << node
      end

    end    
  end
end
