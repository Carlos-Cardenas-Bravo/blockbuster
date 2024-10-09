class AddMovieIdToClients < ActiveRecord::Migration[7.2]
  def change
    add_column :clients, :movie_id, :integer
  end
end
