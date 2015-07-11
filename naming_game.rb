require 'set'
require 'benchmark'
require 'csv'

load 'word.rb'
load 'player.rb'
load 'numeric_player.rb'
load 'game.rb'
load 'network.rb'
load 'random_network.rb'
load 'clique_network.rb'
load 'scale_free_network.rb'
load 'lattice_network.rb'
load 'small_world_network.rb'
load 'metrics.rb'

# Benchmark.bm { |x| x.report { game = Game.new; puts game.run } }



def experiment
  puts "network_size\titeration\tmax_words\titerations\tconvergence\ttime_to_max_words"
  # results = []
  [0.3].each do |probability|
    puts "\n" * 3
    puts probability
    puts "\n" * 3
    (500..800).step(100).each do |network_size|
      (1..30).each do |iteration|
        # network = SmallWorldNetwork.new(network_size, degree) # 2*degree > network_size
        # network = LatticeNetwork.new(network_size, degree)
        # network = ScaleFreeNetwork.new(network_size)
        network = CliqueNetwork.new(network_size)
        # network = RandomNetwork.new(network_size, probability)
        game = Game.new(network)
        result = game.run;
        puts "#{network_size}\t#{iteration}\t#{result[:max_words]}\t#{result[:iterations]}\t#{result[:convergence].id}\t#{result[:time_to_max_words]}"
        # results << [network_size, iteration, result[:max_words], result[:iterations], result[:convergence].id, result[:time_to_max_words]]
      end
    end
  end
end

# experiment


def normalized_time_series(time_series)
  max_time = time_series.map { |t| t.size }.max
  time_series.map do |series|
    series + [series.last] * (max_time - series.size)
  end
end


# puts "Total words: #{result[:total_words].join("\n")}"
# puts "Different words: #{result[:different_words].join("\n")}"

network_size = 200
degree = 50

topologies = [
  { network: 'CliqueNetwork', params: [network_size], name: 'clique' },
  { network: 'RandomNetwork', params: [network_size], name: 'erdos-renyi' },
  { network: 'LatticeNetwork', params: [network_size, degree], name: 'lattice (d=100)' },
  { network: 'LatticeNetwork', params: [network_size, degree / 2], name: 'lattice (d=50)' },
  { network: 'SmallWorldNetwork', params: [network_size, degree / 2, 0.03], name: 'watts-strogatz (d=50, p=3%)' },
  { network: 'SmallWorldNetwork', params: [network_size, degree / 2, 0.05], name: 'watts-strogatz (d=50, p=5%)' }
]
  # { network: 'ScaleFreeNetwork', params: [network_size], name: 'barabasi-albert' },

topologies_total = []
topologies_diff = []
topologies_succ = []

topologies.each do |topology|
  total = []
  diff = []
  succ = []
  network_class = Object.const_get topology[:network]
  params = topology[:params]

  puts topology
  (1..30).each do |iteration|
    n = network_class.new *params
    game = Game.new n
    result = game.run
    total << result[:total_words]
    diff << result[:different_words]
    succ << result[:successes]
    puts "Iterations: #{result[:iterations]}"
    # puts "Max words: #{result[:max_words]}"
    # puts "Time to max words: #{result[:time_to_max_words]}"
  end
  
  total = normalized_time_series(total)
  total_avg = total.transpose.map { |row| row.inject(:+).to_f / row.size }
  topologies_total << total_avg

  diff = normalized_time_series(diff)
  diff_avg = diff.transpose.map { |row| row.inject(:+).to_f / row.size }
  topologies_diff << diff_avg

  succ = normalized_time_series(succ)
  succ_avg = succ.transpose.map { |row| row.inject(:+).to_f / row.size }
  topologies_succ << succ_avg
end

CSV.open('total.csv', 'w') do |csv|
  csv << topologies.map { |t| t[:name] }
  normalized_time_series(topologies_total).transpose.each do |row|
    csv << row
  end;
end;

CSV.open('diff.csv', 'w') do |csv|
  csv << topologies.map { |t| t[:name] }
  normalized_time_series(topologies_diff).transpose.each do |row|
    csv << row
  end;
end;

CSV.open('succ.csv', 'w') do |csv|
  csv << topologies.map { |t| t[:name] }
  normalized_time_series(topologies_succ).transpose.each do |row|
    csv << row
  end;
end;

