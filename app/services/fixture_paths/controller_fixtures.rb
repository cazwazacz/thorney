module FixturePaths
  class ControllerFixtures
    def initialize(path_manager)
      @path_manager = path_manager
    end

    def fixture?(path)
      path.split('/')[2] == 'controllers'
    end

    def spec_and_fixture(path)
      path_manager.spec_fixture_hash(controller_spec_path(path), path_manager.fixture_name(path), path, controller_method: controller_method(path))
    end

    private

    attr_reader :path_manager

    def controller_spec_path(path)
      path = (path.split('/') - ['fixtures']).join('/')

      split_path = path_manager.full_path(path).split('/')

      if controller_spec?(path)
        split_path = split_path[0..split_path.length - 3]
        split_path.insert(controllers_index(split_path), 'integration')
      else
        split_path.pop
      end

      split_path.join('/') + '_spec.rb'
    end

    def controller_method(path)
      split_path = path.split('/')

      split_path[split_path.length - 2] if controller_spec?(path)
    end

    def controllers_index(split_path)
      split_path.find_index('controllers')
    end

    def controller_spec?(path)
      path.include?('_controller')
    end
  end
end