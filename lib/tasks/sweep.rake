require 'optparse'
require_relative '../../app/services/fixture_paths/generic_fixtures'
require_relative '../../app/services/fixture_paths/controller_fixtures'
require_relative '../../app/services/path_manager'
require_relative '../../app/services/fixture_sweeper'

desc 'Delete unused fixture files and folders'
task :sweep do
  simulate = false

  parser = OptionParser.new do |opts|
    opts.on('-s', '--simulate') { simulate = true }
  end

  args = parser.order!(ARGV) {}
  parser.parse!(args)

  FixtureSweeper.new.sweep(simulate: simulate)
end
