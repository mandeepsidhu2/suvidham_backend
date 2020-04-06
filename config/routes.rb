Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
		namespace :v1 do
			get 'ping', to: 'health#hi'
			post 'payment', to: 'payment#payment'
			get 'verify_rfid',to: 'payment#verify_rfid'
			post 'verify_payment',to: 'payment#verify'
		end
	end
end
