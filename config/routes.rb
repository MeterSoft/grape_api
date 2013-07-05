require 'grape'

GrapeApi::Application.routes.draw do

  mount Archive::API => "/api/"
end
