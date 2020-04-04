class Api::V1::HealthController < ApplicationController
	def hi
		 render html: '<h1>pong</h1>'.html_safe
	end
end
