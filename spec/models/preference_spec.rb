require 'rails_helper'

RSpec.describe Preference, type: :model do
  let(:user) { User.create(email: "test#{SecureRandom.hex(4)}@example.com", password: 'password123') }

  subject {
    Preference.new(
      reason: "First date",
      location: "Lisbon",
      when: "Saturday afternoon",
      badget: "medium",
      activities_preference: ["nature", "coffee"],
      final_reason: "Make her feel special",
      time_range_start: "14:00",
      time_range_end: "20:00",
      personality_type: "introverted",
      mobility: "walk",
      weather_tolerance: "sunny",
      romantic_level: 4,
      group_size: 2,
      custom_notes: "Avoid crowded places",
      user_id: user.id
    )
  }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without a user" do
    subject.user = nil
    expect(subject).to_not be_valid
  end
end
