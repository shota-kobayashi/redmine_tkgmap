# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  match 'tkgmap/:action', :to => 'tkgmap'
end
