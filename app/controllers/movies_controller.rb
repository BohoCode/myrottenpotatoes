class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.getRatingsValues
    flash[:notice] = "ratings values are " + @all_ratings.to_s
    sort_by = params[:sort_by]
#flash[:notice] = ":head_class is " + params[:head_class]
    if sort_by == 'title'
      @title_head_style = params[:head_class]
      @rel_date_head_style = ""
    elsif sort_by == 'release_date'
      @title_head_style = ""
      @rel_date_head_style = params[:head_class]
    else
      @title_head_style = ""
      @rel_date_head_style = ""
    end
    @movies = Movie.order("#{params[:sort_by]}").all
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
