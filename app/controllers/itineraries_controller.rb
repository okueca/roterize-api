class ItinerariesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_itinerary, only: %i[destroy save_itinerary]

  # GET /itineraries
  def index
    # return only id, title, content, created_at
    @itineraries = current_user.itineraries.where(is_saved: true).only(:id, :title, :content, :created_at, :is_saved)
    
    # Parse content from string to JSON
    itineraries_with_parsed_content = @itineraries.map do |itinerary|
      {
        id: itinerary.id.to_s,
        title: itinerary.title,
        content: JSON.parse(itinerary.content),
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
end
