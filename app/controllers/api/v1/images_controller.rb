# frozen_string_literal: true

class Api::V1::ImagesController < Api::ApiController
  before_action :doorkeeper_authorize! unless Rails.env.test?

  def index
    @images = current_resource_owner.images
  end

  def create
    @image = Image.new(image_size_params)
    @image.user = current_resource_owner

    # that needed to be done for correct image processing
    @image.content = params[:image][:content]

    respond_with @image unless @image.save
  end

  def update

    @image = current_resource_owner.images.find(params[:id])

    return head 404 unless @image.present?

    if @image.update(image_params)
      @image.content.recreate_versions!(:processed) if params[:content].present?
    else
      respond_with @image
    end

    render 'api/v1/images/image'
  end

  private

  def image_size_params
    params.require(:image).permit(:height, :width)
  end

  def image_params
    params.require(:image).permit(:height, :width, :content)
  end
end
