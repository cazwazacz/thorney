module PageSerializer
  class GroupsShowPageSerializer < PageSerializer::BasePageSerializer
    # Initialise a Groups show page serializer.
    #
    # @param [ActionDispatch::Request] request the current request object.
    # @param [<Grom::Node>] group a Grom::Node object of type Group.
    # @param [Array<Hash>] data_alternates array containing the href and type of the alternative data urls.
    def initialize(request: nil, group: nil, data_alternates: nil)
      @group = group
      super(request: request, data_alternates: data_alternates)
    end

    private

    def meta
      super(title: title)
    end

    def title
      @group.try(:groupName) || t('no_name')
    end

    def content
      [].tap do |components|
        components << ComponentSerializer::SectionComponentSerializer.new(components: section_primary_components, type: 'primary').to_h
        components << ComponentSerializer::SectionComponentSerializer.new(components: section_literals, type: 'section').to_h
      end
    end

    def section_primary_components
      [].tap do |component|
        component << ComponentSerializer::Heading1ComponentSerializer.new(heading_content).to_h
      end
    end

    def heading_content
      {}.tap do |hash|
        hash[:subheading_content] = 'groups.groups'
        hash[:subheading_data] = { link: groups_path }
        hash[:heading_content] = title
        hash[:context_content] = @group.date_range
      end
    end

    def section_literals
      [].tap do |component|
        component << if @group.is_a?(Parliament::Grom::Decorator::LayingBody)
                       ComponentSerializer::ParagraphComponentSerializer.new(
                         content: [{
                           content: 'groups.subsidiary-resources.layings',
                           link:    group_layings_path(@group.try(:graph_id))
                         }]
                       ).to_h
                     end
      end
    end
  end
end
