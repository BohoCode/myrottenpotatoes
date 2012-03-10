class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index_old
    @all_ratings = Movie.getRatingsValues
    @selected_ratings = @all_ratings


    if params[:ratings] != nil
      @selected_ratings = params[:ratings].keys
      logger.debug("Selected ratings are #{@selected_ratings.to_s}")
    end

    @checked_state = Hash.new(false)    
    @selected_ratings.each do |elem| 
      logger.debug("elem is #{elem.to_s}")
      @checked_state[elem]=true 
    end
    logger.debug("@checked_state is #{@checked_state.to_s}")

    sort_by = params[:sort_by]
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

    @movies = Movie.where({:rating=>@selected_ratings}).order("#{params[:sort_by]}").all
  end

  def index
    
    @all_ratings = Movie.getRatingsValues
    @selected_ratings = {}
    if params[:ratings] == nil
      if @selected_ratings.empty?
        if session[:selected_ratings]
          @selected_ratings = session[:selected_ratings]
        else
          @all_ratings.each { |e| @selected_ratings[e] = "on"}
        end
      end
    else
      @selected_ratings = params[:ratings]
    end
    logger.debug("selected_ratings is #{@selected_ratings}")
    session[:selected_ratings]=@selected_ratings

    sort_by = params[:sort_by]
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
    select_criteria = @selected_ratings.select { |k, v| v=="on" }.keys
    logger.debug("select_criteria is #{select_criteria}")
    @movies = Movie.where({:rating=>select_criteria})
                  .order("#{params[:sort_by]}").all
    
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
