class MoviesController < ApplicationController
  before_action :set_movie, only: %i[ show edit update destroy ]

  # GET /movies or /movies.json
  def index
    if params[:query_text].present?
      # Realiza la búsqueda con paginación
      @pagy, @movies = pagy(Movie.search_full_text(params[:query_text]))
      # Si no se encuentran películas, muestra un mensaje y redirige a la lista completa
      if @movies.empty?
        flash[:alert] = "No se encontraron películas que coincidan con la búsqueda."
        redirect_to movies_path and return
      end
    else
      # Si no hay búsqueda, lista todos los tweets con paginación
      @pagy, @movies = pagy(Movie.all)
    end
  end

  # GET /movies/1 or /movies/1.json
  def show
  end

  # GET /movies/new
  def new
    @movie = Movie.new
    @movie.clients.build

  end

  # GET /movies/1/edit
  def edit
    @clients = @movie.clients  # carga los clientes asociados a la película
  end

  # POST /movies or /movies.json
  def create
    @movie = Movie.new(movie_params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: "Película creada exitosamente." }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movies/1 or /movies/1.json
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to @movie, notice: "Película y cliente asociado fueron exitosamente actualizados." }
        format.json { render :show, status: :ok, location: @movie }
      else
        @clients = @movie.clients  # Si hay error, vuelve a cargar la lista de clientes
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1 or /movies/1.json
  def destroy
    @movie = Movie.find(params[:id])

    if @movie.clients.any?
      respond_to do |format|
        format.html { redirect_to movies_path, alert: "No se puede eliminar la película porque está asociada a un cliente." }
        format.json { render json: { error: "No se puede eliminar la película porque está asociada a un cliente." }, status: :unprocessable_entity }
      end
    else
      @movie.destroy!
      respond_to do |format|
        format.html { redirect_to movies_path, status: :see_other, notice: "Película eliminada exitosamente." }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def movie_params
      params.require(:movie).permit(:name, clients_attributes: [:id, :name, :age, :_destroy])

    end
end
