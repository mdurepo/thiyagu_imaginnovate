Rails.application.routes.draw do
  resources :employees do
    collection do
      get :tax_deduction
    end
  end
end
