class Network
  attr_accessor :n, :p, :adjacency_list

  def initialize(n = 100, p = 0.05)
    @n = n
    @p = p
    loop do
      make_adjacency_list
      break if is_connected?
      # puts "Oops, a disconnected network was built!"
    end
  end

  def pick_player
    rand(@n)
  end

  def pick_neighbor_from(node_id)
    @adjacency_list[node_id].sample
  end

  # protected
  def make_adjacency_list
    @adjacency_list = []
    @n.times { @adjacency_list << [] }

    (0 .. @n - 1).each do |node_id|
      # @adjacency_list[node_id] ||= []

      (node_id + 1 .. @n - 1).each do |neighbor_id|
        next if node_id == neighbor_id
        if rand < @p
          # @adjacency_list[neighbor_id] ||= []
          @adjacency_list[node_id] << neighbor_id
          @adjacency_list[neighbor_id] << node_id
          # puts "sucesso: #{node_id} e #{neighbor_id}"
          # puts "node: #{@adjacency_list[node_id].to_s}"
          # puts "neighbor: #{@adjacency_list[neighbor_id].to_s}"
        end
      end
    end
  end

  def is_connected?
    visited = [false] * @n
    stack = [0]

    until stack.empty?
      node = stack.pop
      visited[node] = true
      stack.push *@adjacency_list[node].select { |neighbor| !visited[neighbor] }
    end

    visited.all?
  end
end
