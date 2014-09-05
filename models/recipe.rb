class Recipe
attr_reader :id, :name, :instructions, :description, :ingredients
  def initialize(paramshash)
    @id = paramshash["id"]
    @name = paramshash["name"]
    @instructions = paramshash["instructions"]
    @description = paramshash["description"]
    @ingredients = ''
  end

  def self.db_connection
    begin
      connection = PG.connect(dbname: 'recipes')
      yield(connection)
    ensure
      connection.close
    end
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

end
