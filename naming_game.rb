require 'set'
require 'benchmark'

load 'word.rb'
load 'player.rb'
load 'game.rb'
load 'network.rb'
load 'random_network.rb'
load 'clique_network.rb'
load 'scale_free_network.rb'
load 'lattice_network.rb'
load 'small_world_network.rb'

# Benchmark.bm { |x| x.report { game = Game.new; puts game.run } }



def experiment
  puts "network_size\titeration\tmax_words\titerations\tconvergence\ttime_to_max_words"
  # results = []
  [50].each do |degree|
    puts "\n" * 3
    puts degree
    puts "\n" * 3
    (200..600).step(100).each do |network_size|
      (1..30).each do |iteration|
        network = SmallWorldNetwork.new(network_size, degree) # 2*degree > network_size
        # network = LatticeNetwork.new(network_size, degree)
        # network = ScaleFreeNetwork.new(network_size)
        # network = CliqueNetwork.new(network_size)
        # network = RandomNetwork.new(network_size, probability)
        game = Game.new(network)
        result = game.run;
        puts "#{network_size}\t#{iteration}\t#{result[:max_words]}\t#{result[:iterations]}\t#{result[:convergence].id}\t#{result[:time_to_max_words]}"
        # results << [network_size, iteration, result[:max_words], result[:iterations], result[:convergence].id, result[:time_to_max_words]]
      end
    end
  end
end

experiment
