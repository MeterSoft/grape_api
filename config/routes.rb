require 'grape'

GrapeApi::Application.routes.draw do

  mount Pages::API => "/api/"
  mount Sessions::API => "/api/"
end
