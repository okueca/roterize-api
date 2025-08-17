class Preference
  include Mongoid::Document
  include Mongoid::Timestamps
  field :reason, type: String
  field :location, type: String
  field :when, type: String
  field :badget, type: String
  field :activities_preference, type: Array
  field :final_reason, type: String
  field :time_range_start, type: String
  field :time_range_end, type: String
  field :personality_type, type: String
  field :mobility, type: String
  field :weather_tolerance, type: String
  field :romantic_level, type: Integer
  field :group_size, type: Integer
  field :custom_notes, type: String
  
  belongs_to :user  # Mongoid vai lidar com user_id internamente

end
