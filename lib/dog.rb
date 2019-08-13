class Dog
  attr_accessor :name, :breed, :id

  def initialize(id:nil, name:, breed:)
    self.name = name
    self.breed = breed
    self.id = id
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS dogs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        breed TEXT
      );
    SQL
  end

end
