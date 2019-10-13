class MoviesController < ApplicationController

  attr_accessor :checked 

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    ratings_query = params[:ratings] || session[:ratings]
    puts session[:ratings]
    @all_ratings = Movie.all_ratings
    @sort = params[:sort] || session[:sort]
    if ratings_query != nil
      ratings_keys = ratings_query.keys
      @movies = Movie.with_ratings(ratings_keys)
      @movies = @movies.order(@sort)
      session[:sort] = @sort
      @checked = ratings_query.keys
      session[:ratings] = ratings_query
      # redirect_to :sort => @sort, :ratings =>  
    else
      @movies = Movie.order(@sort) 
      @checked = @all_ratings
      session[:sort] = @sort
      # redirect_to :sort => sort
    end

    if params[:ratings] != session[:ratings] || params[:sort] != session[:sort]
      # session[:ratings] = params[:ratings]
      # session[:sort] = params[:sort]
      redirect_to :sort => @sort, :ratings => ratings_query and return
    end
    # redirect_to movies_path
  end



  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  

  # private
  
  # def sort_column
  #   Movie.column_names.include?(params[:sort]) ? params[:sort] : "name"
  # end
  
  # def sort_direction
  #   %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  # end

end
