require 'rails_helper'

RSpec.describe "Users::Sessions", type: :request do
  let(:headers) { {'Content-Type' => 'application/json'} }
  let(:email) {"testUser#{SecureRandom.hex(4)}@gmail.com"}
  let!(:user) { User.create!(email: email, password: 'secret123', password_confirmation: 'secret123', name: 'Tester')}
  describe "POST /login" do
    it "Login return JWT in Authorization" do
      post '/login', params: { user:{email: email, password: "secret123"}}.to_json, headers: headers
      expect(response).to have_http_status(:ok)
      expect(response.headers['Authorization']).to match(/\ABearer\s.+\z/)
    end
  end
end
