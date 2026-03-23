require 'rails_helper'

RSpec.describe 'Dashboard', type: :request do
  let!(:user) { create(:user) }

  describe 'GET /' do
    it 'returns 200' do
      get root_path
      expect(response).to have_http_status(:ok)
    end

    context 'with walks present' do
      before { create_list(:walk, 3, user: user) }

      it 'returns 200' do
        get root_path
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
