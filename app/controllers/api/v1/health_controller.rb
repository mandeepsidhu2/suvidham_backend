class Api::V1::HealthController < ApplicationController
	def hi
		 render html: '<h1>teri pehn di</h1>'.html_safe
	end
end
