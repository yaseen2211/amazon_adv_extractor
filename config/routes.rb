Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  root "dashboard#index"
  post '/extract_adv_results', to: 'client_advertisment_results#process_results', as: 'extract_adv_results'
  get '/adv_file_uploader', to: 'client_advertisment_results#adv_file_uploader', as: 'adv_file_uploader'
end
