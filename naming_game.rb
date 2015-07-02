require 'set'
require 'benchmark'

load 'word.rb'
load 'player.rb'
load 'game.rb'
load 'network.rb'
load 'random_network.rb'
load 'clique_network.rb'

# Benchmark.bm { |x| x.report { game = Game.new; puts game.run } }



def experiment
  puts "network_size\titeration\tmax_words\titerations\tconvergence\ttime_to_max_words"
  # results = []
  [0.05].each do |probability|
    puts "\n" * 3
    puts probability
    puts "\n" * 3
    (100..1300).step(100).each do |network_size|
      (1..30).each do |iteration|
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

experiment
