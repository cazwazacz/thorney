require_relative '../../rails_helper'

RSpec.describe FixturePaths::ControllerFixtures do
  let(:path_manager_double) { double('path_manager_double', fixture_name: 'fixture_name') }

  subject { described_class.new(path_manager_double) }

  context '#fixture?' do
    context 'when it is a controller fixture' do
      it 'returns true' do
        path = 'spec/fixtures/controllers/groups_controller/index/fixture.yml'

        expect(subject.fixture?(path)).to eq true
      end
    end

    context 'when it is not a controller fixture' do
      it 'returns false' do
        path = 'spec/fixtures/serializers/component_serializer/list_component_serializer/generic.yml'

        expect(subject.fixture?(path)).to eq false
      end
    end
  end

  context '#spec_and_fixture' do
    let(:root) { __dir__.chomp('spec/services/fixture_paths') }

    context 'when it is a controller spec' do
      it 'calls the correct method on path manager with the correct arguments' do
        path = 'spec/fixtures/controllers/groups_controller/index/fixture.yml'
        spec_path = root + 'spec/integration/controllers/groups_controller_spec.rb'

        allow(path_manager_double).to receive(:spec_fixture_hash)
        allow(path_manager_double).to receive(:full_path) { root + 'spec/controllers/groups_controller/index/fixture.yml' }

        subject.spec_and_fixture(path)

        expect(path_manager_double).to have_received(:spec_fixture_hash).with(spec_path, 'fixture_name', path, controller_method: 'index')
      end
    end

    context 'when it is a helper in concerns' do
      it 'calls the correct method on path manager with the correct arguments' do
        path = 'spec/fixtures/controllers/concerns/pagination_helper/create_number_cards.yml'
        spec_path = root + 'spec/controllers/concerns/pagination_helper_spec.rb'

        allow(path_manager_double).to receive(:spec_fixture_hash)
        allow(path_manager_double).to receive(:full_path) { root + 'spec/controllers/concerns/pagination_helper/create_number_cards.yml' }

        subject.spec_and_fixture(path)

        expect(path_manager_double).to have_received(:spec_fixture_hash).with(spec_path, 'fixture_name', path, controller_method: nil)
      end
    end
  end
end
