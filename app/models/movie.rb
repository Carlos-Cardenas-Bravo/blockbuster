class Movie < ApplicationRecord
    has_many :clients, dependent: :restrict_with_error

    accepts_nested_attributes_for :clients, allow_destroy: true

end
