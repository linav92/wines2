class Wine < ApplicationRecord
    has_many :assemblies,  dependent: :destroy
    has_many :strains, through: :assemblies,  dependent: :destroy
    has_many :critics
    has_many :winemakers, through: :critics
    has_and_belongs_to_many :winemakers
    accepts_nested_attributes_for :assemblies, :critics
end
