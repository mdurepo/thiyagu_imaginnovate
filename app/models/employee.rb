class Employee < ApplicationRecord
    validates :employee_id, presence: true, uniqueness: true
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :salary, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :doj, presence: true
    validates :phone_numbers, presence: true
    validate :validate_phone_numbers
  

    def validate_phone_numbers
      phone_numbers_list = phone_numbers.split(',')
      phone_numbers_list.each do |phone_number|
        unless phone_number.match?(/\A\d{10}\z/)
          errors.add(:phone_numbers, "contains invalid phone number: #{phone_number}")
        end
      end
    end
  end