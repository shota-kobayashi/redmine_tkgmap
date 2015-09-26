# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  get 'tkgmap/:action', to: 'tkgmap', via: [:get, :post]
end
