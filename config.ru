require_relative 'app/api'
run ExpenseTracker::API.new(ledger: Ledger.new)