# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  get 'tkgmap', :to => 'tkgmap#index'
  get 'tkgmap/window', :to => 'tkgmap#window'
end
