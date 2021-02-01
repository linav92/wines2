class AddIsReviewerToWinemaker < ActiveRecord::Migration[6.0]
  def change
    add_column :winemakers, :is_reviewer, :boolean
  end
end
