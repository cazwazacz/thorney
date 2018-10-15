class PathManager
  def initialize(generic_fixtures = FixturePaths::GenericFixtures, controller_fixtures = FixturePaths::ControllerFixtures)
    @generic_fixtures = generic_fixtures.new(self)
    @controller_fixtures = controller_fixtures.new(self)
  end

  def fixture_parent_folder(path_hash)
    parent_folder = path_hash[:fixture_path].split('/')
    parent_folder.pop
    parent_folder = parent_folder.join('/')

    full_path(parent_folder + '/')
  end

  def spec_and_fixture(path)
    return controller_fixtures.spec_and_fixture(path) if controller_fixtures.fixture?(path)

    generic_fixtures.spec_and_fixture(path)
  end

  def full_path(path)
    root = __dir__.chomp('app/services')

    root + path
  end

  def list_paths(paths, stdout: $stdout)
    paths.each do |path|
      stdout.puts path
    end
  end

  def fixture_name(path)
    path.split('/').last
  end

  def spec_fixture_hash(spec, fixture_name, fixture_path, controller_method: nil)
    {}.tap do |hash|
      hash[:spec] = spec
      hash[:fixture_name] = fixture_name
      hash[:fixture_path] = fixture_path
      hash[:controller_method] = controller_method if controller_method
    end
  end

  private

  attr_reader :generic_fixtures, :controller_fixtures
end
