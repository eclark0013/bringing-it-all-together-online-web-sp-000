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

    DB[:conn].execute(sql)
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE IF EXISTS dogs;")
  end

  def save
    sql = <<-SQL
      INSERT INTO dogs (name, breed)
      VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.breed)
    self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs;").first.first
    self
  end

  def self.create(name:, breed:)
    dog = Dog.new(name:name, breed:breed)
    dog.save
    dog
  end

  def self.new_from_db(row)
    Dog.new(id:row[0], name:row[1], breed:row[2])
  end

  def self.find_by_id(id)
    sql = <<-SQL
      SELECT * FROM dogs
      WHERE id = ?
    SQL

    row = DB[:conn].execute(sql, id).first
    self.new_from_db(row)
  end

  def self.find_or_create_by(name:, breed:nil)
    row = DB[:conn].execute("SELECT * FROM dogs WHERE name = ?", name).first
    if !row.empty?
      if row[2] == breed
        self.new_from_db(row)
      else
        self.create(name:name, breed:breed)
      end
    else
      self.create(name:name, breed:breed)
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM dogs
      WHERE name = ?
    SQL

    row = DB[:conn].execute(sql, name).first
    dog = self.find_or_create_by(name:name, breed:row[2])
  end

  def update
    sql = <<-SQL
      UPDATE dogs SET name = ?, breed = ? WHERE id = ?
    SQL
    DB[:conn].execute(sql, self.name, self.breed, self.id)
  end


end
