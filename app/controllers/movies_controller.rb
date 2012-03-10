class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    @all_ratings = Movie.getRatingsValues
    @selected_ratings = {}
    @require_redirect = false
    #setup params if not set.
    if params[:ratings] 
      @selected_ratings = params[:ratings]
      session[:selected_ratings] = params[:ratings]
    else
      #no ratings passed in - do we have any cached?
      if session[:selected_ratings]
        # Yes we do - set params to the cached versions ready
        # for a redirect
        params[:ratings] = session[:selected_ratings]
        logger.debug("session params exist, so redirecting to #{movies_path params}")
        requre_redirect = true
      else
        # Likely to be first time loaded. No session or passed in
        # ratings sorting values. Set all availiable ratings to on.
        # ready for redirect
       
        @all_ratings.each { |e| @selected_ratings[e] = "on"}
        params[:ratings] = @selected_ratings
        require_redirect = true
      end
    end

    logger.debug("selected_ratings is #{@selected_ratings}")


    if params[:sort_by]
      #set cached sorting criteria
      session[:sort_by] = params[:sort_by]
    elsif
      # No sorting creteria passed in. Are there cached criteria?
      if session[:sort_by]
        params[:sort_by] = session[:sort_by]
        require_redirect = true
      else
        # no sorting prams passed in, or cached. Need to set to default values
        params[:sort_by]='title'
        require_redirect = true
      end
    end

    if require_redirect 
      redirect_to movies_path params
    end 


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
