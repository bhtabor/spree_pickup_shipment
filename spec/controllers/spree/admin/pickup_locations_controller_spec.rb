require 'spec_helper'

describe Spree::Admin::PickupLocationsController do
  let(:user) { mock_model(Spree::User) }

  describe '#new' do
    before(:each) do
      allow(controller).to receive(:spree_current_user).and_return(user)
      allow(user).to receive(:generate_spree_api_key!).and_return(true)
      allow(controller).to receive(:authorize!).and_return(true)
      allow(controller).to receive(:authorize_admin).and_return(true)
    end

    context 'when a default country is found' do
      before do
        country = FactoryBot.create(:country)
        Spree::Config[:default_country_id] = country.id
        get :new
      end

      it 'renders response with success status' do
        expect(response.status).to eq(200)
      end

      it 'builds a new pickup_location' do
        expect(assigns(:pickup_location)).to be_an_instance_of(Spree::PickupLocation)
      end
    end

    context 'when a default country is not found' do
      before do
        allow(Spree::Country).to receive(:default).and_return(nil)
        get :new
      end

      it 'renders response with redirect status' do
        expect(response.status).to eq(302)
      end

      it 'redirects to admin_pickup_locations_path' do
        expect(response).to redirect_to(admin_pickup_locations_path)
      end
    end
  end

  describe '#index' do
    let!(:pickup_locations) { FactoryBot.create_list(:pickup_location, 2, :with_timings) }

    before(:each) do
      allow(controller).to receive(:spree_current_user).and_return(user)
      allow(user).to receive(:generate_spree_api_key!).and_return(true)
      allow(controller).to receive(:authorize!).and_return(true)
      allow(controller).to receive(:authorize_admin).and_return(true)
      get :index
    end

    it 'renders response with success status' do
      expect(response.status).to eq(200)
    end

    it 'renders index template' do
      expect(response).to render_template(:index)
    end
  end
end
