require 'rails_helper'

RSpec.describe Strain, type: :model do
  describe "Las cepas no pueden tener el mismo nombre" do 
    it 'validates uniqueness name' do
      expect(Strain.validates_uniqueness_of(:name))
    end
  end

  describe "Una cepa no puede tener un nombre vacío" do 
    it 'validates name not empty' do
      strain  = Strain.new(name: "")
      expect(strain).to_not be_valid
    end
  end

  describe "Una cepa no puede tener un nombre vacío" do 
    it 'validates name not nil' do
      strain  = Strain.new(name: nil)
      expect(strain).to_not be_valid
    end
  end

  describe "Una cepa no puede tener un nombre vacío" do 
    it 'validates name carmenere' do
      strain  = Strain.new(name: "Carmenere")
      expect(strain).to be 
    end
  end
 
end