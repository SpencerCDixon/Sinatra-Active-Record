class Ingredient
attr_reader :id, :name, :recipe_id

  def initialize(args)
    @id = args['id']
    @name = args['name']
    @recipe_id = args['recipe_id']
  end
  #
  # def self.db_connection
  #   begin
  #     connection = PG.connect(dbname: 'recipes')
  #     yield(connection)
  #   ensure
  #     connection.close
  #   end
  # end

end
