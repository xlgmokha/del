require 'spec_helper'

RSpec.describe Del::Repository do
  subject { described_class.new(storage: storage, mapper: mapper) }
  let(:storage) { Hash.new }
  let(:mapper) { double(:mapper, map_from: nil) }

  describe "#[]" do
    let(:id) { SecureRandom.uuid }
    let(:attributes) { { id: id, name: 'Teren Delvon Jones' } }
    let(:user) { instance_double(Del::User) }

    before do
      subject.upsert(id, attributes)
      allow(mapper).to receive(:map_from).with(attributes).and_return(user)
    end

    specify { expect(subject[id]).to eql(user) }
    specify { expect(subject.find(id)).to eql(user) }
    specify { expect(subject.find(SecureRandom.uuid)).to be_nil }
  end

  describe "#find_all" do
    let(:del_attributes) { { name: 'Teren Delvon Jones' } }
    let(:ice_cube_attributes) { { name: "O'Shea Jackson Sr." } }
    let(:del) { instance_double(Del::User) }
    let(:cube) { instance_double(Del::User) }

    it 'returns each item' do
      subject.upsert(SecureRandom.uuid, del_attributes)
      subject.upsert(SecureRandom.uuid, ice_cube_attributes)
      allow(mapper).to receive(:map_from).with(del_attributes).and_return(del)
      allow(mapper).to receive(:map_from).with(ice_cube_attributes).and_return(cube)

      expect(subject.find_all).to match_array([ del, cube ])
    end
  end
end
