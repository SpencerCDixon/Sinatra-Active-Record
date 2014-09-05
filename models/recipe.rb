require_relative 'ingredient'
require_relative '../server'
class Recipe

attr_reader :id, :name, :instructions, :description

  def initialize(hash)
    @id = hash["id"]
    @name = hash["name"]
    @instructions = hash["instructions"] || "This recipe doesn't have any instructions."
    @description = hash["description"] || "This recipe doesn't have a description."
  end

  def self.all
    sql = 'SELECT * FROM recipes'

    results = db_connection do |db|
      db.exec_params(sql)
    end

    recipes = []
    results.to_a.each do |result|
      recipes << Recipe.new(result)
    end
    recipes
  end

  def self.find(id)
    sql = 'SELECT * FROM recipes WHERE id = $1 LIMIT 1'

    result = db_connection do |db|
      db.exec_params(sql, [id])
    end
    recipe = Recipe.new(result[0])
    recipe
  end

  def ingredients
    sql = %Q{
      SELECT ingredients.name, ingredients.id, ingredients.recipe_id FROM ingredients
      JOIN recipes ON ingredients.recipe_id = recipes.id
      WHERE recipe_id = $1
    }
    results = db_connection do |db|
      db.exec_params(sql, [id])
    end
    ingredients = []
    results.to_a.each do |result|
      ingredients << Ingredient.new(result)
    end
    ingredients
  end

end
