require_relative '../../app/api'
require 'rack/test'
require 'spec_helper'

module ExpenseTracker
  RecordResult = Struct.new(:success?, :expense_id, :error_message)

  RSpec.describe API do
    include Rack::Test::Methods

    let(:ledger) { ExpenseTracker::Ledger.new }

    def app
      ExpenseTracker::API.new(ledger)
    end

    def expect_on_body(last_response)
      expect(JSON.parse(last_response.body))
    end
  
    def expect_on_status(last_response)
      expect(last_response.status)
    end

    describe 'GET /expenses/:date' do
      context 'when expenses exist on the given date' do
        pending('GET valid expenses exists')
        it 'returns the expense records as JSON' do
        end
        it 'responds with 200 (OK)' do
        end
      end

      context 'when there are no expenses on the given date' do
        pending('GET No expenses found')
        it 'returns an empty array as JSON' do
        end
        it 'responds with a 200 (OK)' do
        end
      end
    end

    describe 'POST /expenses' do
      context 'when the expense is successfully recorded' do

        let(:expense) { {
          'expense_id' => 417,
          'payee' => 'Starbucks',
          'amount' => 5.75,
          'date' => '2017-06-10'
        } }

        before do
          allow(ledger).to receive(:record).with(expense)
            .and_return(RecordResult.new(true, 417, nil))
        end

        it 'returns the expense id' do
          post '/expenses', JSON.generate(expense)
          expect_on_body(last_response).to include('expense_id' => 417)
        end
        it 'responds with a HTTP 200 (OK)' do
          post '/expenses', JSON.generate(expense)
          expect_on_status(last_response).to eq(200)
        end
      end

      context 'when the expense fails validation' do
        let(:expense) { {
          'some' => 'data'
        } }

        let(:error_message) { 'Expense incomplete' }

        before do
          allow(ledger).to receive(:record)
            .with(expense)
            .and_return(RecordResult.new(false, 417, error_message))
        end

        it 'returns an error message' do
          post '/expenses', JSON.generate(expense)
          expect_on_body(last_response).to include('error' => error_message)
        end
        it 'responds with a HTTP 422 (Unprocessable entity)' do
          post '/expenses', JSON.generate(expense)
          expect_on_status(last_response).to eq(422)
        end
      end
    end
  end
end
