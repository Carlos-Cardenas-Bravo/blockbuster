class Client < ApplicationRecord
    belongs_to :movie, optional: true  # permite que el cliente no tenga peliculas
end
