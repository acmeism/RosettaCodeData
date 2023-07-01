# Global variable
$number_of_continents = 7

module Banking
  # Module constants for semantic versioning
  VERSION = '1.0.0.1'
  class BankAccount
    attr_accessor :first_name, :last_name
    attr_reader :account_number

    @@ATM_FEE = 3.75
    @@adiministrator_password = 'secret'

    # The class's constructor
    def initialize(first_name, last_name, account_number)
      @first_name = first_name
      @last_name = last_name
      @account_number = account_number
      @balance = 0
    end

    # Explicit setter as extra behavior is required
    def account_number=(account_number)
      puts 'Enter administrator override'
      if gets == @@adiministrator_password
        @account_number = account_number
      else
        puts 'Sorry. Incorrect password. Account number not changed'
      end
    end

    # Explicit getter as extra behavior is required
    def balance
      "$#{@balance / 100}.#{@balance % 100}"
    end

    # Check if account has sufficient funds to complete transaction
    def sufficient_funds? (withdrawal_amount)
      withdrawal_amount <= @balance
    end

    # Destructive method
    def donate_all_money!
      @balance = 0
    end
  end
end
