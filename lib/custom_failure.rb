class CustomFailure < Devise::FailureApp
  def respond
    # Always return JSON for this API only application
    json_failure
  end

  def json_failure
    self.status = 401
    self.content_type = 'application/json'
    self.response_body = {
      status: 401,
      message: i18n_message
    }.to_json
  end
end
