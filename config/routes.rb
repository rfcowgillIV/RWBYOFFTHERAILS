Rails.application.routes.draw do
  get 'welcome/index'
 
  resources :articles do
    resources :comments
  end
  
  resources :passwords do
  end


  root 'welcome#index'
end