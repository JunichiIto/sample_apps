module UsersHelper
  # キーワード引数を持つメソッドの定義(5.4.3)
  # 引数で与えられたユーザーのGravatar画像を返す
  def gravatar_for(user, size: 80)
    # 二重コロンを使ってメソッドを呼び出す(コラム324ページ)
    gravatar_id  = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
