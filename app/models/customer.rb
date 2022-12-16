class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

         has_many :addresses, dependent: :destroy
         has_many :cart_items, dependent: :destroy
         has_many :orders, dependent: :destroy

         validates :first_name, :last_name, :first_name_kana, :last_name_kana, :address, :telephone_number, presence: true

  def full_name
    [last_name, first_name].join(' ')
  end

  def full_name_kana
    [last_name_kana, first_name_kana].join(' ')
  end

  def active_for_authentication?
    super && (is_deleted == false)
  end
end
