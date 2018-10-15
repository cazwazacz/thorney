module FixturePaths
  class VcrFixtures
    def initialize(path_manager)
      @path_manager = path_manager
    end

    private

    def vcr_fixture?(path)
      path.include?('vcr_cassettes')
    end

    def vcr_spec_path(path)
      path = path.split('/')

      vcr_lambdas[cassette_type(path)].call(path)
    end

    def cassette_folder(path)
      path[path.index('vcr_cassettes') + 1]
    end

    def cassette_type(path)
      cassette_folder(path).split(/(?=[A-Z])/).last.to_sym
    end

    def vcr_lambdas
      {
          Controller: lambda { |path| vcr_controller_spec_paths(path) },
          Serializer: lambda { |path| vcr_serializer_spec_path(path) }
      }
    end

    def vcr_controller_spec_paths(path)
      parent_folders = cassette_folder(path).split('_')[0...-1].join('/').downcase
      parent_folders += '/' unless parent_folders.empty?

      spec_filename = cassette_folder(path).split('_').last.split(/(?=[A-Z])/).map { |word| word.downcase }.join('_') + '_spec.rb'

      {
          controller: root + 'spec/controllers/' + parent_folders + spec_filename,
          integration: root + 'spec/integration/controllers/' + parent_folders + spec_filename
      }
    end

    def root
      __dir__.chomp('app/services/fixture_paths')
    end
  end
end