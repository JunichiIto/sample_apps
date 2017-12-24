class Micropost < ApplicationRecord
  # メソッド呼び出しをDSL風に使う(コラム424ページ)
  belongs_to :user
  # ラムダをメソッドの引数として渡す(10.3.3, 10.3.4)
  default_scope -> { order(created_at: :desc) }
  # クラス自身もオブジェクト(8.5.7)
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  # この{}はハッシュの{}(5.2)
  validates :content, presence: true,
                      length: { maximum: 140 }
  validate  :picture_size

  private

    # アップロードされた画像のサイズをバリデーションする
    def picture_size
      # megabytesメソッドはRailsの独自拡張(A.2)
      if picture.size > 1.megabytes
        errors.add(:picture, "should be less than 1MB")
      end
    end
end
