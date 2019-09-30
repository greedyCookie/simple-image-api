class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  #TODO config app to delete images on user deletion

  version :processed do
    process :custom_resize_to_fill
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  def custom_resize_to_fill
    resize_to_fill(model.width, model.height) if model.width.present? && model.height.present?
  end

end
