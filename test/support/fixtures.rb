class Recipe < Spyke::Base
  has_many :groups
  has_one :image
  has_one :background_image, class_name: 'Image', uri: nil
  has_one :alternate, class_name: 'Recipe', uri: '/recipes/:recipe_id/alternates/recipe'
  belongs_to :user

  scope :published, -> { where(status: 'published') }
  scope :approved, -> { where(approved: true) }
  attributes :title

  before_save :before_save_callback
  before_create :before_create_callback
  before_update :before_update_callback

  accepts_nested_attributes_for :image, :user, :groups

  def self.page(number)
    where(page: number)
  end

  def ingredients
    groups.first.ingredients
  end

  private

    def before_create_callback; end
    def before_update_callback; end
    def before_save_callback; end
end

class Image < Spyke::Base
  method_for :create, :put
end

class StepImage < Image
end

class RecipeImage < Image
  uri '/recipes/:recipe_id/image'
  validates :url, presence: true
  attributes :url
  include_root_in_json false
end

class Group < Spyke::Base
  has_many :ingredients, uri: nil
  accepts_nested_attributes_for :ingredients
end

class Ingredient < Spyke::Base
  uri '/recipes/:recipe_id/ingredients/:id'
end

class User < Spyke::Base
  has_many :recipes
end

class Photo < Spyke::Base
  uri '/images/photos/:id'
end

class Comment < Spyke::Base
  scope :approved, -> { where(comment_approved: true) }
end
