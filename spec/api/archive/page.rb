require "spec_helper"

describe Archive do
	describe 'pages' do
		let(:user) { FactoryGirl.create(:user) }
		before { Archive::API.any_instance.stub(:current_user).and_return(user) }

		context 'should return all pages' do
			let!(:page) { FactoryGirl.create(:page, user_id: user.id) }

			before { get '/api/pages' }
			
			it { expect(response).to be_success }
      it { expect(response.status).to eq(200) }
			it { expect(JSON.parse(response.body)).to eq(JSON.parse(page.to_json)) }
		end

		context 'should create page' do
			let(:params) { FactoryGirl.attributes_for(:page) }

			before { post '/api/pages', page: params.merge(user_id: user.id) }
			
			it { expect(response).to be_success }
      it { expect(response.status).to eq(201) }
			it { expect(JSON.parse(response.body)).to eq({ "success"=>true }) }
		end

		context 'should return page with id' do
			let(:page) { FactoryGirl.create(:page) }

			before { get "/api/pages/#{page.id}" }
			
			it { expect(response).to be_success }
      it { expect(response.status).to eq(200) }
			it { expect(JSON.parse(response.body)).to eq(JSON.parse(page.to_json)) }
		end

		context 'should update page with id' do
			let(:page) { FactoryGirl.create(:page) }

			before { put "/api/pages/#{page.id}" }
			
			it { expect(response).to be_success }
      it { expect(response.status).to eq(200) }
			it { expect(JSON.parse(response.body)).to eq({ "success"=>true }) }
		end

		context 'should delete page with id' do
			let(:page) { FactoryGirl.create(:page) }

			before { delete "/api/pages/#{page.id}" }
			
			it { expect(response).to be_success }
      it { expect(response.status).to eq(200) }
			it { expect(JSON.parse(response.body)).to eq({ "success"=>true }) }
		end

		context 'should return published pages' do
			let!(:page) { FactoryGirl.create(:page, published_on: Time.now) }
			let!(:another_page) { FactoryGirl.create(:page) }

			before { get "/api/pages/published" }
			
			it { expect(response).to be_success }
      it { expect(response.status).to eq(200) }
			it { expect(JSON.parse(response.body)).to eq(JSON.parse([page].to_json)) }
		end

		context 'should return unpublished pages' do
			let!(:page) { FactoryGirl.create(:page, published_on: Time.now) }
			let!(:another_page) { FactoryGirl.create(:page) }

			before { get "/api/pages/unpublished" }
			
			it { expect(response).to be_success }
      it { expect(response.status).to eq(200) }
			it { expect(JSON.parse(response.body)).to eq(JSON.parse([another_page].to_json)) }
		end

		context 'should set published page' do
			let(:page) { FactoryGirl.create(:page) }

			before { post "/api/pages/#{page.id}/published" }
			
			it { expect(response).to be_success }
      it { expect(response.status).to eq(201) }
			it { expect(JSON.parse(response.body)).to eq({ "success"=>true }) }
		end

		context 'should return total words from page' do
			let(:page) { FactoryGirl.create(:page) }

			before { get "/api/pages/#{page.id}/total_words" }
			
			it { expect(response).to be_success }
      it { expect(response.status).to eq(200) }
			it { expect(JSON.parse(response.body)).to eq({ "count"=>4 }) }
		end
	end
end