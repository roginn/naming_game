class CliqueNetwork < Network
  def initialize(n = 100)
    @size = n
  end

  def pick_neighbor_of(node_id)
    ((0 .. @size - 1).to_a - [node_id]).sample
  end
end
