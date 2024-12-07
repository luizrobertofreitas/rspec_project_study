require 'spec_helper'
require 'rack/test'
require 'json'

require_relative '../../app/api'

module ExpenseTracker
  RSpec.describe 'Expense Tracker API' do
    include Rack::Test::Methods

    def app
      ExpenseTracker::API.new(ledger)
    end

    let(:ledger) { instance_double('ExpenseTracker::Ledger') }

    def post_expense(expense)
      post '/expenses', JSON.generate(expense)
      expect(last_response.status).to eq(200)
      parsed = JSON.parse(last_response.body)
      expect(parsed).to include('expense_id' => a_kind_of(Integer))
      expense.merge('id' => parsed['expense_id'])
    end

    it 'records submitted expenses' do
      pending('Need to persist expenses')
      coffee = post_expense({
          'expense_id' => 100,
          'payee' => 'Starbucks',
          'amount' => 5.75,
          'date' => '2017-06-10'
      })
      zoo = post_expense({
        'expense_id' => 200,
        'payee' => 'Zoo',
        'amount' => 15.25,
        'date' => '2017-06-10'
      })
      groceries = post_expense({
        'expense_id' => 300,
        'payee' => 'Whole Foods',
        'amount' => 95.20,
        'date' => '2017-06-11'
      })
      
      get '/expenses/2017-06-10'
      expect(last_response.status).to eq(200)
      expenses = JSON.parse(last_response.body)
      expect(expenses).to contain_exactly(coffee, zoo)
    end
  end
end
