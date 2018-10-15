require_relative '../../rails_helper'

RSpec.describe FixturePaths::VcrFixtures do
  let(:path_manager_double) { double('path_manager_double') }

  subject { described_class.new(path_manager_double) }

  context 'vcr cassettes' do
    let(:root) { __dir__.chomp('spec/services/fixture_paths') }

    context '#vcr_fixture?' do
      it 'returns true if it is a vcr fixture' do
        path = 'spec/fixtures/vcr_cassettes/GroupsController/GET_current/navigating_to_the_current_page/renders_expected_JSON_output.yml'

        expect(subject.send(:vcr_fixture?, path)).to eq true
      end

      it 'returns false if it is not a vcr fixture' do
        path = 'spec/fixtures/serializers/component_serializer/list_component_serializer/generic.yml'

        expect(subject.send(:vcr_fixture?, path)).to eq false
      end
    end

    context '#vcr_spec_path' do
      context 'controller vcr fixture' do
        it 'returns the correct spec path' do
          path = 'spec/fixtures/vcr_cassettes/GroupsController/GET_current/navigating_to_the_current_page/renders_expected_JSON_output.yml'

          expected = {
              controller: root + 'spec/controllers/groups_controller_spec.rb',
              integration: root + 'spec/integration/controllers/groups_controller_spec.rb'
          }

          expect(subject.send(:vcr_spec_path, path)).to eq expected
        end
      end

      context 'it is a nested controller vcr fixture' do
        it 'returns the correct spec path' do
          path = 'spec/fixtures/vcr_cassettes/Groups_LayingsController/GET_index/navigating_to_the_index_page/renders_expected_JSON_output.yml'

          expected = {
              controller: root + 'spec/controllers/groups/layings_controller_spec.rb',
              integration: root + 'spec/integration/controllers/groups/layings_controller_spec.rb'
          }

          expect(subject.send(:vcr_spec_path, path)).to eq expected
        end
      end

      context 'serializer vcr fixture' do
        it 'returns the correct spec path' do
          path = 'spec/fixtures/vcr_cassettes/PageSerializer_GroupsShowPageSerializer/group_not_laying_body/produces_the_expected_JSON_hash_without_layings.yml'

          expected = root + 'spec/serializers/page_serializer/groups_show_page_serializer_spec.rb'

          expect(subject.send(:vcr_spec_path, path)).to eq expected
        end
      end

      context 'helper vcr fixture' do
        xit 'returns the correct spec path' do

        end
      end

      context 'service vcr fixture' do
        xit 'returns the correct spec path' do

        end
      end
    end
  end
end
