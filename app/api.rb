require 'sinatra/base'
require 'json'

require_relative 'ledger'

module ExpenseTracker
  class API < Sinatra::Base
    def initialize(ledger)
      @ledger = ledger
      super()
    end

    set(:probability) { |value| condition { rand <= value } }

    post '/expenses' do
      # halt 404
      expense = JSON.parse(request.body.string)
      result = @ledger.record(expense)
      if result.success?
        JSON.generate({"expense_id": result.expense_id})
      else
        halt 422, JSON.generate('error' => result.error_message)
      end
    end

    get '/expenses/:date' do
      JSON.generate([])
    end

    get '/win_a_car', :probability => 0.1 do
      "You won!"
    end
  end
end