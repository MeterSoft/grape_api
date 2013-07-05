FactoryGirl.define do 
	sequence :title do |n|
    "title#{n}"
  end

	factory :page do
		content 'test some test'
		title
		association :user
		published_on nil
	end
end