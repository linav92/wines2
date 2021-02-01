class Winemaker < ApplicationRecord
    has_many :critics
    has_many :wines, through: :critics
end
