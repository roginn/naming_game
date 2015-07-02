class Network
  attr_reader :size

  def pick_player
    rand(@size)
  end

  def pick_neighbor_of(node_id)
    @adjacency_list[node_id].sample
  end

  def is_connected?
    visited = [false] * @size
    stack = [0]

    until stack.empty?
      node = stack.pop
      visited[node] = true
      stack.push *@adjacency_list[node].select { |neighbor| !visited[neighbor] }
    end

    visited.all?
  end
end
