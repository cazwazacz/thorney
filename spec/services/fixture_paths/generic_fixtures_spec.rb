require_relative '../../rails_helper'

RSpec.describe FixturePaths::GenericFixtures do
  let(:path_manager_double) { double('path_manager_double', fixture_name: 'fixture_name') }

  subject { described_class.new(path_manager_double) }

  context '#spec_and_fixture' do
    let(:root) { __dir__.chomp('spec/services/fixture_paths') }

    it 'calls the correct method on path manager with the correct arguments' do
      path = 'spec/fixtures/serializers/component_serializer/list_component_serializer/generic.yml'
      spec_path = root + 'spec/serializers/component_serializer/list_component_serializer_spec.rb'

      allow(path_manager_double).to receive(:spec_fixture_hash)
      allow(path_manager_double).to receive(:full_path) { root + 'spec/serializers/component_serializer/list_component_serializer/generic.yml' }

      subject.spec_and_fixture(path)

      expect(path_manager_double).to have_received(:spec_fixture_hash).with(spec_path, 'fixture_name', path)
    end
  end
end
