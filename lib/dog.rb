class Dog
  attr_accessor :name, :breed

  def initialize(id:nil, name:, breed:)
    self.name = name
    self.breed = breed
    self.id = id
  end
end
