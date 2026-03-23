require 'rails_helper'

RSpec.describe DashboardPresenter do
  subject(:presenter) { described_class.new(user, time: time) }
  let(:user) { build(:user) }

  describe '#greeting' do
    context 'hours 0-11' do
      let(:time) { Time.zone.local(2024, 1, 1, 6, 0, 0) }
      it { expect(presenter.greeting).to eq('Good morning') }
    end

    context 'hours 12-16' do
      let(:time) { Time.zone.local(2024, 1, 1, 14, 0, 0) }
      it { expect(presenter.greeting).to eq('Good afternoon') }
    end

    context 'hours 17-23' do
      let(:time) { Time.zone.local(2024, 1, 1, 20, 0, 0) }
      it { expect(presenter.greeting).to eq('Good evening') }
    end
  end
end
