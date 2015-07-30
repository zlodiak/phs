class AlbumsController < ApplicationController
  before_action :set_album, only: [:show, :edit, :update, :destroy]
  before_action :admin_or_owner_check, only: [:edit, :update, :destroy]

  def index
    @albums = current_user.albums
    @album = Album.new
  end

  def show
    @user = @album.user
  end

  def new
  end

  def edit
  end

  def create
    @album = current_user.albums.build(album_params)

    if @album.save
      render json: @album, :status => 200 
    else
      render json: @album.errors.full_messages, :status => 403 
    end
  end

  def update
    if @album.update_attributes(album_params)
      flash[:success] = :album_updated
      redirect_to user_album_path(current_user, @album)
    else
      flash[:error] = :album_not_updated
      render  'edit'
    end
  end

  def destroy
    if @album.destroy
      render nothing: true, :status => 200 
    else      
      render nothing: true, :status => 403 
    end
  end

  def get_album_data

  end

  private

    def set_album
      @album = Album.find(params[:id])
    end

    def album_params
      params.require(:album).permit(:title, :description)
    end

    def admin_or_owner_check
      unless admin_status || @album.user.id == current_user.id
        render nothing: true, :status => 403 
      end
    end    
end
