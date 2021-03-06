class ProcedureStepsController < ApplicationController
  before_action :build_request, :data_check

  ROUTE_MAP = {
    index: proc { ParliamentHelper.parliament_request.procedure_step_index },
    show:  proc { |params| ParliamentHelper.parliament_request.procedure_step_by_id.set_url_params({ procedure_step_id: params[:procedure_step_id] }) }
  }.freeze

  def index
    @procedure_steps = FilterHelper.filter(@api_request, 'ProcedureStep')
    @procedure_steps = @procedure_steps.sort_by(:procedureStepName, :graph_id)

    list_components = @procedure_steps.map do |procedure_step|
      houses_description = nil

      if procedure_step.try(:procedureStepHasHouse)
        houses_string = procedure_step.try(:procedureStepHasHouse).map { |house| house.try(:houseName) }.compact.sort.to_sentence
        houses_description = [{ term: { content: 'procedure-steps.houses' }, description: [{ content: houses_string }] }] if houses_string
      end

      paragraph_content = [{ content: procedure_step.try(:procedureStepDescription) }] if procedure_step.try(:procedureStepDescription)

      CardFactory.new(
        heading_text:      procedure_step.try(:procedureStepName),
        heading_url:       procedure_step_path(procedure_step.graph_id),
        description_list_content: houses_description,
        paragraph_content: paragraph_content
      ).build_card
    end

    heading = ComponentSerializer::Heading1ComponentSerializer.new(heading: I18n.t('procedure_steps.index.title'))

    serializer = PageSerializer::ListPageSerializer.new(request: request, heading_component: heading, list_components: list_components, data_alternates: @alternates)

    render_page(serializer)
  end

  def show
    @procedure_step = FilterHelper.filter(@api_request, 'ProcedureStep')
    @procedure_step = @procedure_step.first

    serializer = PageSerializer::ProcedureStepsShowPageSerializer.new(request: request, procedure_step: @procedure_step, data_alternates: @alternates)

    render_page(serializer)
  end
end
