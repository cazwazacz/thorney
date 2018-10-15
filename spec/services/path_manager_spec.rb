require_relative '../rails_helper'

RSpec.describe PathManager do
  let(:root) { __dir__.chomp('spec/services') }

  it '#fixture_parent_folder' do
    path_hash = { fixture_path: 'spec/fixtures/serializers/component_serializer/list_component_serializer/generic.yml' }

    expect(subject.fixture_parent_folder(path_hash)).to eq "#{root}spec/fixtures/serializers/component_serializer/list_component_serializer/"
  end

  context '#spec_and_fixture' do
    it 'if it is a controller fixture' do
      path = 'spec/fixtures/controllers/search_controller/index/empty_query.yml'

      expected = {
          controller_method: 'index',
          spec: "#{root}spec/integration/controllers/search_controller_spec.rb",
          fixture_name: 'empty_query.yml',
          fixture_path: 'spec/fixtures/controllers/search_controller/index/empty_query.yml'
      }

      expect(subject.spec_and_fixture(path)).to eq expected
    end

    it 'if it is a generic fixture' do
      path = 'spec/fixtures/serializers/component_serializer/list_component_serializer/generic.yml'

      expected = {
          spec: "#{root}spec/serializers/component_serializer/list_component_serializer_spec.rb",
          fixture_name: 'generic.yml',
          fixture_path: 'spec/fixtures/serializers/component_serializer/list_component_serializer/generic.yml'
      }

      expect(subject.spec_and_fixture(path)).to eq expected
    end
  end

  it '#full_path' do
    expect(subject.full_path('hello')).to eq "#{root}hello"
  end

  it '#list_paths' do
    stdout_double = double('stdout_double', puts: '')

    subject.list_paths([1], stdout: stdout_double)

    expect(stdout_double).to have_received(:puts).with 1
  end

  xcontext 'vcr cassettes' do
    let(:root) { __dir__.chomp('services') }

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
        xit 'returns the correct spec path' do
          path = 'spec/fixtures/vcr_cassettes/GroupsController/GET_current/navigating_to_the_current_page/renders_expected_JSON_output.yml'

          expected = {
              controller: root + 'spec/controllers/groups_controller_spec.rb',
              integration: root + 'spec/integration/controllers/groups_controller_spec.rb'
          }

          expect(subject.send(:vcr_spec_path, path)).to eq expected
        end
      end

      context 'it is nested controller vcr fixture' do
        xit 'returns the correct spec path' do
          path = 'spec/fixtures/vcr_cassettes/Groups_LayingsController/GET_index/navigating_to_the_index_page/renders_expected_JSON_output.yml'

          expected = {
              controller: root + 'spec/controllers/groups/layings_controller_spec.rb',
              integration: root + 'spec/integration/controllers/groups/layings_controller_spec.rb'
          }

          expect(subject.send(:vcr_spec_path, path)).to eq expected
        end
      end

      context 'serializer vcr fixture' do
        xit 'returns the correct spec path' do

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