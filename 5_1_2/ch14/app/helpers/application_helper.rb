# モジュールの定義(8.2.2)
module ApplicationHelper
  # デフォルト値を持つ引数(2.11.1)
  # ページごとの完全なタイトルを返します。
  def full_title(page_title = '')
    base_title = "Ruby on Rails Tutorial Sample App"
    if page_title.empty?
      base_title
    else
      # 文字列リテラルの式展開(2.3.1)
      "#{page_title} | #{base_title}"
    end
  end
end
