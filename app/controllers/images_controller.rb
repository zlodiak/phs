class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :edit, :update, :destroy, :get_image_data]
  before_action :logged_check, only: [:create, :create_direct, :edit, :update, :destroy]
  before_action :owner_check, only: [:image_poll_associated]

  def index
    @images = Image.where(is_delete: nil).paginate(page: params[:page], :per_page => 18).order(created_at: :DESC)  
  end

  def show
    image_detail = Image.find(image_params[:image_id])
    owner = User.find(image_detail.user_id)

    if image_detail
      render json: {
        url_giant: image_detail.image.url(:giant),
        description: image_detail.description,
        album_id: image_detail.album_id,
        album_title: image_detail.album.title,
        url_original: image_detail.image.url,
        user_id: image_detail.user_id,
        created_at: l(image_detail.created_at, format: "%e %b %Y, %H:%I"),
        updated_at: l(image_detail.updated_at, format: "%e %b %Y, %H:%I"),
        owner: owner.name
      }, :status => 200 
    else
      render nothing: true, :status => 404 
    end
  end

  def new
    @image = Image.new
    @albums = current_user.albums
  end

  def edit
  end

  def create  
    @image = Image.create(image_params)   

    if @image.save
      @image.update_attributes(user: current_user)
      render json: @image, :status => 200 
    else
      render json: @image.errors.full_messages, :status => 403 
    end
  end

  def create_direct  
    @errors = [] 
    
    # error messages construct block
    @errors.push 'Выберите альбом' if image_params[:album_id].to_i == 0
    @errors.push 'Выберите картинку' if image_params[:image] == ''

    # response block
    if (image_params[:album_id].to_i != 0 && image_params[:image] != '')
      @image = Image.create(image_params) 
      @image.update_attributes(user: current_user)
      render json: { album_title: @image.album.title }, :status => 200       
    else
     render json: @errors, :status => 403 
    end
  end  

  def update
    if @image.update_attributes(image_params)
      render json: @image, :status => 200 
    else
      render json: @image.errors.full_messages, :status => 403 
    end
  end

  def destroy
    if @image.update_attributes(is_delete: true)
      render nothing: true, :status => 200 
    else      
      render nothing: true, :status => 403 
    end
  end

  def get_image_data
    if @image
      render json: @image, :status => 200 
    else
      render nothing: true, :status => 404  
    end
  end  

  def image_poll_associated
    @image = Image.find(poll_params[:image_id])

    if(poll_params[:operation] == 'link')
      # ready variable for add image to poll
      poll_id_value = poll_params[:poll_id]
    else
      # ready variable for remove image from poll
      poll_id_value = nil
    end

    # insert variable to image table
    if @image.update_attributes(:poll_id => poll_id_value)
      # remove likes for this image
      ImageLike.where(image_id: poll_params[:image_id]).destroy_all

      # ready return poll title value
      if(poll_params[:operation] == 'link')
        json_returned = { poll_title: @image.poll.title } 
      else
        json_returned = {} 
      end
      
      render json: json_returned, :status => 200 
    else
      render nothing: true, :status => 404  
    end 
  end

  private

    def set_image
      @image = Image.find(params[:id])
    end

    def image_params
      params.require(:image).permit(:description, :image, :album_id, :image_id, :poll_id)
    end

    def poll_params
      params.permit(:user_id, :image_id, :poll_id, :operation)
    end    

    def owner_check
      @image = Image.find(poll_params[:image_id])

      unless (admin_status) || (@image.user_id == current_user.id)
        render nothing: true, :status => 403 
      end
    end     
end
