require 'readline'
require 'openai'

class OpenAIClient
  def initialize
    @client = OpenAI::Client.new(
      access_token: ENV['OPEN_API_SECRET_KEY']
    )
    @messages = []
  end

  def chat(prompt)
    response = @client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: @messages + [{ role: "user", content: prompt }],
      })
    add_message('user', prompt)
    # p [:response, response]
    ans = response.dig("choices", 0, "message")
    ans['content']&.strip.tap do |content|
      add_message(ans['role'], content)
    end
  end

  def add_message(role, content)
    @messages << { role: role, content: content }
  end
end

client = OpenAIClient.new

loop do
  prompt = Readline.readline('prompt> ', true)
  break unless prompt
  if prompt == 'exit'
    break
  else
    puts client.chat(prompt)
  end
end
