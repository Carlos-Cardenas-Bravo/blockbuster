class Movie < ApplicationRecord
    has_many :clients, dependent: :restrict_with_error

    accepts_nested_attributes_for :clients, allow_destroy: true

    include PgSearch::Model
    pg_search_scope :search_full_text,
    against: [:name ],
    using: {
        tsearch: { prefix: true } # Permite búsqueda parcial
    }

end
