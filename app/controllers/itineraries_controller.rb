class ItinerariesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_itinerary, only: %i[destroy save_itinerary]

  # GET /itineraries
  def index
    # return only id, title, content, created_at
    @itineraries = current_user.itineraries.where(is_saved: true).only(:id, :title, :content, :created_at, :is_saved)

    # Parse content from string to JSON, skipping any records that fail to parse
    # (e.g. legacy records saved with markdown code fences around the JSON)
    itineraries_with_parsed_content = @itineraries.filter_map do |itinerary|
      parsed_content = safe_parse_json(itinerary.content)

      if parsed_content.nil?
        next
      end

      {
        id: itinerary.id.to_s,
        title: itinerary.title,
        content: parsed_content,
        created_at: itinerary.created_at,
        is_saved: itinerary.is_saved
      }
    end

    render json: itineraries_with_parsed_content
  end

  # DELETE /itineraries/:id
  def destroy
    @itinerary.destroy!
    head :no_content
  end

  # PATCH/PUT /itineraries/:id/save_itinerary
  def save_itinerary
    if @itinerary.update(is_saved: true)
      render json: @itinerary, status: :ok
    else
      render json: @itinerary.errors, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_itinerary
    @itinerary = current_user.itineraries.find(params[:id])
  end

  # Some itinerary content was saved with markdown code fences (```json ... ```)
  # wrapped around it, from the raw Claude API response. Strip those before
  # parsing so both old and new records load correctly. Returns nil (instead
  # of raising) if the content still can't be parsed as JSON, so callers can
  # skip the record rather than 500ing the whole request.
  def safe_parse_json(raw)
    cleaned = raw.to_s.strip.sub(/\A```(?:json)?\s*/, '').sub(/```\s*\z/, '').strip
    JSON.parse(cleaned)
  rescue JSON::ParserError
    Rails.logger.warn("Itinerary content could not be parsed as JSON: #{raw.to_s.truncate(100)}")
    nil
  end
end
