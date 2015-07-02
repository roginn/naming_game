require 'set'
require 'benchmark'

load 'word.rb'
load 'player.rb'
load 'game.rb'
load 'network.rb'

Benchmark.bm { |x| x.report { game = Game.new; puts game.run } }

def experiment
  puts "network_size\titerations\tmax_words\titerations\tconvergence\ttime_to_max_words"
  (100..2000).step(100).each do |network_size|
    (1..30).each do |iteration|
      game = Game.new network_size;
      result = game.run;
      puts "#{network_size}\t#{iteration}\t#{result[:max_words]}\t#{result[:iterations]}\t#{result[:convergence].id}\t#{result[:time_to_max_words]}"
    end
  end
end
