class ApplicationRecord < ActiveRecord::Base
  # クラス構文の直下でクラスのプロパティ（インスタンスのプロパティではない）を変更する(7.5.2)
  # セッターメソッドの呼び出し（selfを省略するとローカル変数への代入と見なされる）(7.5.1)
  self.abstract_class = true
end
