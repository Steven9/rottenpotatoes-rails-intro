class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings
    if params[:ratings] || session[:ratings]
      @filter = params[:ratings] || session[:ratings]
    else
      @filter = Hash[@all_ratings.map {|rating| [rating, rating]}]
    end
    
    sort = params[:sort] || session[:sort]
    if params[:sort] == "title"
      @title_header = 'hilite'
    elsif params[:sort] == "release_date"
      @release_date_header = 'hilite'
    else
      @title_header = ''
      @release_date_header = ''
    end
    
    if params[:sort] != session[:sort] or params[:ratings] != session[:ratings]
      session[:sort] = sort
      session[:ratings] = @filter
      redirect_to :sort => sort, :ratings => @filter and return
    end
    @movies = Movie.where(rating: @filter.keys).order(sort)
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

end
