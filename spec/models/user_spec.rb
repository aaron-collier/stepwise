require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(build(:user)).to be_valid
    end

    %i[first_name last_name email].each do |attr|
      it "validates presence of #{attr}" do
        user = build(:user, attr => nil)
        expect(user).not_to be_valid
        expect(user.errors[attr]).to include("can't be blank")
      end
    end

    it 'validates uniqueness of email' do
      create(:user, email: 'taken@example.com')
      duplicate = build(:user, email: 'taken@example.com')
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:email]).to include('has already been taken')
    end
  end

  describe 'associations' do
    it 'has many walks' do
      assoc = described_class.reflect_on_association(:walks)
      expect(assoc.macro).to eq(:has_many)
      expect(assoc.options[:dependent]).to eq(:destroy)
    end
  end
end
