module FixturePaths
  class GenericFixtures
    def initialize(path_manager)
      @path_manager = path_manager
    end

    def spec_and_fixture(path)
      path_manager.spec_fixture_hash(spec_path(path), path_manager.fixture_name(path), path)
    end

    private

    attr_reader :path_manager

    def spec_path(path)
      path = (path.split('/') - ['fixtures']).join('/')
      split_path = path_manager.full_path(path).split('/')

      split_path.pop
      split_path.join('/') + '_spec.rb'
    end
  end
end