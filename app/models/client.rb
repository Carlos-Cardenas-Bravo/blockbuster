class Client < ApplicationRecord
    belongs_to :movie, optional: true  # permite que el cliente no tenga peliculas

    include PgSearch::Model
    pg_search_scope :search_full_text,
    against: [:name ],
    using: {
        tsearch: { prefix: true } # Permite búsqueda parcial
    }
end
