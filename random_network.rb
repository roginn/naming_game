class RandomNetwork < Network
  def initialize(n = 100, p = 0.05)
    @size = n
    @p = p
    loop do
      make_adjacency_list
      break if is_connected?
      # puts "Oops, a disconnected network was built!"
    end
  end

  # protected
  def make_adjacency_list
    @adjacency_list = []
    @size.times { @adjacency_list << [] }

    (0 .. @size - 1).each do |node_id|
      (node_id + 1 .. @size - 1).each do |neighbor_id|
        next if node_id == neighbor_id
        if rand < @p
          @adjacency_list[node_id] << neighbor_id
          @adjacency_list[neighbor_id] << node_id
          # puts "sucesso: #{node_id} e #{neighbor_id}"
          # puts "node: #{@adjacency_list[node_id].to_s}"
          # puts "neighbor: #{@adjacency_list[neighbor_id].to_s}"
        end
      end
    end
  end
end
