require 'rails_helper'

RSpec.describe 'Profile', type: :request do
  let!(:user) { create(:user) }

  describe 'GET /profile' do
    it 'returns 200' do
      get profile_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /profile/edit' do
    it 'returns 200' do
      get edit_profile_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'PATCH /profile' do
    context 'with valid params' do
      it 'redirects to profile_path' do
        patch profile_path, params: {
          user: { first_name: 'Aaron', last_name: 'Collier', email: user.email }
        }
        expect(response).to redirect_to(profile_path)
      end
    end

    context 'with invalid params' do
      it 'returns 422' do
        patch profile_path, params: {
          user: { first_name: 'Aaron', last_name: 'Collier', email: '' }
        }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
