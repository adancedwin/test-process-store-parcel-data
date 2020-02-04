Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'batches#new', as: '/'
  get 'process' => 'batches#create'
end
