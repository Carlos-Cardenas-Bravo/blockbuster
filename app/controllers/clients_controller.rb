class ClientsController < ApplicationController
  before_action :set_client, only: %i[ show edit update destroy ]

  # GET /clients or /clients.json
  def index
    if params[:query_text].present?
      # Realiza la búsqueda con paginación
      @pagy, @clients = pagy(Client.search_full_text(params[:query_text]))
      # Si no se encuentran clientes, muestra un mensaje y redirige a la lista completa
      if @clients.empty?
        flash[:alert] = "No se encontraron clientes que coincidan con la búsqueda."
        redirect_to clients_path and return
      end
    else
      # Si no hay búsqueda, lista todos los tweets con paginación
      @pagy, @clients = pagy(Client.all)
    end
  end

  # GET /clients/1 or /clients/1.json
  def show
  end

  # GET /clients/new
  def new
    @client = Client.new
  end

  # GET /clients/1/edit
  def edit
  end

  # POST /clients or /clients.json
  def create
    @client = Client.new(client_params)

    respond_to do |format|
      if @client.save
        format.html { redirect_to @client, notice: "Client creado exitosamente." }
        format.json { render :show, status: :created, location: @client }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clients/1 or /clients/1.json
  def update
    respond_to do |format|
      if @client.update(client_params)
        format.html { redirect_to @client, notice: "Cliente actualizado exitosamente." }
        format.json { render :show, status: :ok, location: @client }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/1 or /clients/1.json
  def destroy
    @client = Client.find(params[:id])
    if @client.movie.present?
      respond_to do |format|
        format.html { redirect_to clients_path, alert: "No se puede eliminar el cliente porque tiene una película asociada." }
        format.json { render json: { error: "No se puede eliminar el cliente porque tiene una película asociada." }, status: :unprocessable_entity }
      end
    else
      @client.destroy!
      respond_to do |format|
        format.html { redirect_to clients_path, status: :see_other, notice: "Cliente eliminado exitosamente." }
        format.json { head :no_content }
      end
    end
  end

  # Muestra el formulario para asignar una película a un cliente existente
  def assign_movie

    puts "Parámetros recibidos: #{params.inspect}"

    @client = Client.find(params[:id])
    @movies = Movie.all # carga todas las películas para la vista

    if @client.movie.present?
      flash.now[:alert] = "El cliente ya tiene una película asignada."
      render :assign_movie and return
    end

# se actualiza el cliente con la peli seleccionada
    if @client.update(client_params)

      puts "Película asignada: #{@client.movie_id}"

      flash[:notice] = "Película asignada correctamente."
      redirect_to @client # redirijo a la página del cliente
    else
      flash.now[:alert] = "No se pudo asignar la película. Inténtalo de nuevo."
      render :assign_movie
    end
  end

# Procesa la asignación de la película al cliente
#  def update_movie
#
#    puts "Parámetros recibidos: #{params.inspect}"

#    @client = Client.find(params[:id])

#    puts "cliente encontrado: #{@client.id}"

#    if params[:client][:movie_id].present?
#     @client.movie_id = params[:client][:movie_id]

#   if client_params[:movie_id].present?
#      @client.movie_id = client_params[:movie_id]

#    if params[:client].present? && params[:client][:movie_id].present?
#      @client.movie_id = params[:client][:movie_id]  # Asigna la película al cliente

#      puts "Película asignada: #{@client.movie_id}"

#      if @client.save

#        puts "Película guardada exitosamente: #{@client.movie_id}"

#        redirect_to @client, notice: 'Película asignada exitosamente al cliente.'
#      else

#      puts "Error al guardar la película: #{@client.errors.full_messages.join(", ")}"

#        @movies = Movie.all
#        flash.now[:alert] = "Hubo un problema al asignar la película."
#        render :assign_movie, status: :unprocessable_entity
#      end
#    else
#      flash.now[:alert] = "Por favor, selecciona una película para asignar."
#      @movies = Movie.all
#      render :assign_movie and return
#    end
#  end


  private
    def set_client
      @client = Client.find(params[:id])
    end

    def client_params
      #params.require(:client).permit(:name, :age, :movie_id)
      params.require(:client).permit(:movie_id)
    end
end
