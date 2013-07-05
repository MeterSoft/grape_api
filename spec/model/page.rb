require "spec_helper"

describe Page do

  it { should validate_presence_of :title }
  it { should validate_presence_of :content }
  it { should validate_presence_of :user_id }
  it { should validate_uniqueness_of :title }

  context 'associations' do
    it { should belong_to(:user) }
  end
end