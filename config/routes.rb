Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/coastaldata/:station/:startdate/:enddate/:prediction', to: 'coastal_data#show'
end
