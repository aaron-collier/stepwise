Rails.application.routes.draw do
  root "dashboard#index"

  get   "/profile",      to: "profile#show",   as: :profile
  get   "/profile/edit", to: "profile#edit",   as: :edit_profile
  patch "/profile",      to: "profile#update"

  get "up" => "rails/health#show", as: :rails_health_check

  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
