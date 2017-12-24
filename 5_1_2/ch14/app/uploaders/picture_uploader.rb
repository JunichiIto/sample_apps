class PictureUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  process resize_to_limit: [400, 400]

  # クラス構文の直下に処理を書く(7.5.2)
  if Rails.env.production?
    storage :fog
  else
    storage :file
  end


  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_whitelist
    # %リテラルを使って文字列の配列を作成する(4.7.10)
    %w(jpg jpeg gif png)
  end

end
