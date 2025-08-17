require 'rails_helper'

RSpec.describe "Users::Registrations", type: :request do
  describe "POST /signup" do
    let(:headers) { {'Content-Type' => 'application/json'} }

    it "Success Signup" do
      payload = {
        user: {
          email: "newuser#{SecureRandom.hex(4)}@test.com",
          name: 'New User',
          password: '123456',
          password_confirmation: '123456'
        }
      }.to_json

      expect {
        post '/signup', params: payload, headers: headers
      }. to change(User, :count).by(1)
      
      expect([200, 201]).to include(response.status)
    end

    it "Unsuccess Signup" do
      post '/signup', params: { user: {email: 'bademail@g', password: '1234'}}.to_json, headers: headers 
      expect(response).to have_http_status(:unprocessable_entity).or have_http_status(:bad_request)
    end

  end
end
