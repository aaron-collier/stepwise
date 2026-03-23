require 'rails_helper'

RSpec.describe 'Walks', type: :request do
  let!(:user) { create(:user) }
  let!(:walk) { create(:walk, user: user) }

  describe 'GET /walks' do
    it 'returns 200' do
      get walks_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /walks/new' do
    it 'returns 200' do
      get new_walk_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /walks' do
    context 'with valid params' do
      it 'redirects to /walks' do
        post walks_path, params: { walk: { distance_miles: 3.5, steps: 5000, walked_on: Date.today } }
        expect(response).to redirect_to(walks_path)
      end
    end

    context 'with invalid params' do
      it 'returns 422' do
        post walks_path, params: { walk: { distance_miles: '', steps: '', walked_on: '' } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET /walks/:id/edit' do
    it 'returns 200' do
      get edit_walk_path(walk)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'PATCH /walks/:id' do
    context 'with valid params' do
      it 'redirects to /walks' do
        patch walk_path(walk), params: { walk: { distance_miles: 4.0, steps: 6000, walked_on: Date.today } }
        expect(response).to redirect_to(walks_path)
      end
    end

    context 'with invalid params' do
      it 'returns 422' do
        patch walk_path(walk), params: { walk: { distance_miles: '' } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /walks/:id' do
    it 'redirects to /walks' do
      delete walk_path(walk)
      expect(response).to redirect_to(walks_path)
    end
  end
end
