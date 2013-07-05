FactoryGirl.define do
	sequence :username do |n|
    "username#{n}"
  end

	factory :user do
		username
		password '1111'
		role 'admin'
	end
end