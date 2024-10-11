require 'faker'

# Crear 100 películas
#100.times do
#  Movie.create!(
#   name: Faker::Movie.title
#  )
#end

# Crear 10 clientes y asignarles una película aleatoria
#10.times do
#  Client.create!(
#    name: Faker::Name.name,
#    age: Faker::Number.between(from: 18, to: 100),
#    movie_id: Movie.pluck(:id).sample  # Asignar una película aleatoria al cliente
#  )
#end

20.times do
  Client.create!(
    name: Faker::Name.name,
    age: Faker::Number.between(from: 18, to: 100)
  )
end