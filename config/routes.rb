Rails.application.routes.draw do
  get "welcome/index"

  # 2026 update: comments only need a "create" route. The old `resources :comments`
  # also advertised index/show/edit/update/destroy URLs that had no code behind them.
  resources :articles do
    resources :comments, only: :create
  end

  # 2026 update: same idea - The Vault only has an index page, so only that route exists.
  resources :passwords, only: :index

  # Health check for hosting providers: returns 200 if the app boots, 500 if not.
  get "up" => "rails/health#show", as: :rails_health_check

  root "welcome#index"
end
