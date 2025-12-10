class PreferencesController < ApplicationController
  before_action :set_preference, only: %i[ show update destroy ]
  before_action :authenticate_user!

  # GET /preferences
  def index
    @preferences = Preference.all

    render json: @preferences
  end

  # GET /preferences/1
  def show
    render json: @preference
  end

  # POST /preferences
  def create
    @preference = Preference.new(preference_params)
    @preference.user_id = current_user.id
    if @preference.save
      model = "gpt-3.5-turbo"
      chatCall = ChatgptService.new(build_raw_prompt(@preference), model)
      chatCall.call
      content = chatCall.content
      iti = Itinerary.create!(content: content, raw_prompt: build_raw_prompt(@preference), started_at: @preference.time_range_start, ended_at: @preference.time_range_end,
            location: @preference.location, model_used: model, tokens_used: chatCall.tokens_used, generated_at: @preference.created_at, user_id: @preference.user_id, preference_id: @preference.id, is_saved: false)
      itinerary_activities = extract_activities(iti.content, iti.id)
      iti.update!(title: itinerary_activities["title"])
      
      render json: itinerary_activities , status: :created
    else
      render json: @preference.errors, status: :unprocessable_entity
    end
    
  end

  # PATCH/PUT /preferences/1
  def update
    if @preference.update(preference_params)
      render json: @preference
    else
      render json: @preference.errors, status: :unprocessable_entity
    end
  end

  # DELETE /preferences/1
  def destroy
    @preference.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_preference
      @preference = Preference.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def preference_params
      params.require(:preference).permit(:reason, :location, :when, :badget, :final_reason, :time_range_start, :time_range_end, :personality_type, :mobility, :weather_tolerance, :romantic_level, :group_size, :custom_notes, activities_preference: [])
    end

    def build_raw_prompt(preference)
      <<~PROMPT
        You are an intelligent assistant that helps users plan special moments with people they care about.

        Generate a personalized itinerary based on the following user preferences:

        - Reason for the moment: #{preference.reason}
        - Location: #{preference.location}
        - Date or time period: #{preference.when}
        - Budget: #{preference.badget} (low, medium, or high)
        - Preferred activities: #{preference.activities_preference.join(', ')}
        - Time range: from #{preference.time_range_start} to #{preference.time_range_end}
        - Personality of the companion: #{preference.personality_type} (e.g., introverted, extroverted, romantic)
        - Mobility: #{preference.mobility} (e.g., walk, public transport, car)
        - Weather tolerance: #{preference.weather_tolerance} (e.g., sunny, indoor_only)
        - Romantic level: #{preference.romantic_level} (1 to 5)
        - Group size: #{preference.group_size} people
        - Extra notes: #{preference.custom_notes}

        Your response MUST follow this exact JSON structure:

        {
          "title": "string",
          "activities": [
            {
              "title": "string",
              "time": "HH:MM-HH:MM",
              "location": "string",
              "description": "string"
            }
          ]
        }

        Rules:
        - Return ONLY valid JSON. No explanations, no markdown, no extra text.
        - The list of activities must fit within the specified time range.
        - Activities must flow naturally (no abrupt jumps).
        - Adapt choices to mobility, weather, personality, budget, and romantic level.
        - Use real local spots when possible.
        - Keep descriptions short, clear, and charming.
        - Do not repeat activities unless intentional.

        Return ONLY the JSON object. Do not add any commentary.
      PROMPT
    end

    def build_raw_prompt_2(preference)
      <<~PROMPT
        You are an intelligent assistant that helps users plan special moments with people they care about.

        Generate a personalized itinerary based on the following user preferences:

        - Reason for the moment: #{preference.reason}
        - Location: #{preference.location}
        - Date or time period: #{preference.when}
        - Budget: #{preference.badget} (low, medium, or high)
        - Preferred activities: #{preference.activities_preference.join(', ')}
        - Time range: from #{preference.time_range_start} to #{preference.time_range_end}
        - Personality of the companion: #{preference.personality_type} (e.g., introverted, extroverted, romantic)
        - Mobility: #{preference.mobility} (e.g., walk, public transport, car)
        - Weather tolerance: #{preference.weather_tolerance} (e.g., sunny, indoor_only)
        - Romantic level: #{preference.romantic_level} (1 to 5)
        - Group size: #{preference.group_size} people
        - Extra notes: #{preference.custom_notes}

        Respond with a detailed plan for the moment, including:
        - A title
        - A list of suggested activities with estimated times
        - Places or types of locations to visit (with variety and flow)
        - Short descriptions for each activity

        Make it charming, practical, and tailored to the user's input. The total duration must fit within the selected time range. Mention local spots if possible. Avoid repeating activities unless it's intentional (e.g., food + walk + sunset).
      PROMPT
    end

    def extract_activities(itinerary_text, itinerary_id)
      parsed_data = JSON.parse(itinerary_text)
      parsed_data.merge("itinerary_id" => itinerary_id.to_s)
    end

end
