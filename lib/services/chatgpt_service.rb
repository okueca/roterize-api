# @note: This service is used to call the Anthropic API to generate a response to a message
# @note: The API key is stored in the credentials file
# @param message [String] The message to generate a response for
# @param model [String] The model to use for the response
# @return [String] The generated response
# @example
#   ClaudeService.call('What is your name?')
#   => "I'm Claude, an AI assistant made by Anthropic."
# API Docs: https://docs.claude.com/en/api/messages
class ChatgptService
  include HTTParty
  attr_reader :api_url, :options, :model, :message

  def initialize(message, model = 'claude-sonnet-4-6')
    api_key = Rails.application.credentials.anthropic_api_key

    @options = {
      headers: {
        'Content-Type' => 'application/json',
        'x-api-key' => api_key,
        'anthropic-version' => '2023-06-01'
      }
    }
    @api_url = 'https://api.anthropic.com/v1/messages'
    @model = model
    @message = message

    # result
    @content = nil
    @tokens_used = 0
  end

  def call
    body = {
      model: model,
      max_tokens: 1024,
      messages: [{ role: 'user', content: message }]
    }

    response = HTTParty.post(api_url, body: body.to_json, headers: options[:headers], timeout: 10)

    raise response['error']['message'] unless response.code == 200

    @content = response['content'][0]['text']
    @tokens_used = response['usage']['input_tokens'] + response['usage']['output_tokens']
    @content
  end

  def tokens_used
    @tokens_used
  end

  def content
    @content
  end

  class << self
    def call(message, model = 'claude-sonnet-4-6')
      new(message, model).call
    end
  end
end
