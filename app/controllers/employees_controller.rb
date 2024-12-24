class EmployeesController < ApplicationController
    skip_before_action :verify_authenticity_token #Uncomment this line if you using postman


    def create
        employee = Employee.new(employee_params)
        if employee.save
        render json: { message: 'Employee Data created successfully', employee: employee }, status: :created
        else
        render json: { errors: employee.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def tax_deduction
        employees = Employee.all
        results = employees.map do |employee|
          calculate_tax(employee)
        end
    
        render json: results
      end
    
    private
    def employee_params
        params.require(:employee).permit(:employee_id, :first_name, :last_name, :email, :phone_numbers, :doj, :salary)
    end

    def calculate_tax(employee)
        employee_salary = employee.salary
        employee_joining_date = employee.doj

        months_worked_by_employee = calculate_months_worked_by_employee(employee_joining_date)
        total_employee_salary = employee_salary * (months_worked_by_employee / 12.0)
        tax_amount = calculate_tax_amount(total_employee_salary)
        cess_amount = calculate_cess(total_employee_salary)
        loss_of_pay_per_day = employee_salary / 30.0
        {
            employee_code: employee.employee_id,
            first_name: employee.first_name,
            last_name: employee.last_name,
            yearly_salary: employee_salary,
            tax_amount: tax_amount,
            cess_amount: cess_amount,
            total_salary: total_employee_salary,
            loss_of_pay_per_day: loss_of_pay_per_day
        }
    end

    def calculate_months_worked_by_employee(employee_joining_date)
        return 12 if employee_joining_date.nil? || employee_joining_date.month == 1
        months_worked_by_employee = 12 - (employee_joining_date.month - 1)
        months_worked_by_employee
    end

    def calculate_tax_amount(total_salary)
        tax_amount = 0
        if total_salary <= 250000
            tax_amount = 0
        elsif total_salary <= 500000
            tax_amount = (total_salary - 250000) * 0.05
        elsif total_salary <= 1000000
            tax_amount = 12500 + (total_salary - 500000) * 0.10
        else
            tax_amount = 12500 + 50000 + (total_salary - 1000000) * 0.20
        end
        tax_amount
    end

    def calculate_cess(total_salary)
        return 0 if total_salary <= 2500000
        excess_salary = total_salary - 2500000
        cess_amount = excess_salary * 0.02
        cess_amount
    end
end
