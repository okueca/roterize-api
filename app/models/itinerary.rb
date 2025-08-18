class Itinerary
  include Mongoid::Document
  include Mongoid::Timestamps
  field :title, type: String
  field :content, type: String
  field :raw_prompt, type: String
  field :started_at, type: String
  field :ended_at, type: String
  field :location, type: String
  field :model_used, type: String
  field :tokens_used, type: Integer
  field :generated_at, type: Time
  belongs_to :preference
  belongs_to :user
end
