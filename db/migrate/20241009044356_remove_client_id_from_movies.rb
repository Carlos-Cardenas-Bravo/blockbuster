class RemoveClientIdFromMovies < ActiveRecord::Migration[7.2]
  def change
    remove_column :movies, :client_id, :integer
  end
end
