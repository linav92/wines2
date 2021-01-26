class Wine < ApplicationRecord
    has_many :assemblies,  dependent: :destroy
    has_many :strains, through: :assemblies,  dependent: :destroy
    accepts_nested_attributes_for :assemblies
end
