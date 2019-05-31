require_relative('../db/sql_runner')


class Film

  attr_reader :id
  attr_accessor :title, :price

  def initialize(options)
    @title = options['title']
    @price = options['price'].to_i
    @id = options['id'] if options ['id']
  end

#CREATE
  def save()
    sql = "INSERT INTO films
    (
      title, price
    )
    VALUES
    (
      $1, $2
    ) RETURNING id"
    values = [@title, @price]
    result = SqlRunner.run(sql, values).first
    @id = result['id'].to_i
  end

#UPDATE
  def update()
    sql = "UPDATE films SET
    (
      title, price
    )
    =
    (
      $1, $2
    ) WHERE id = $3"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

#DELETE
  def delete()
    sql = "DELETE FROM films WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

#READ
  def self.all()
    sql = "SELECT * FROM films"
    films = SqlRunner.run(sql)
    return films.map {|film| Film.new(film)}
  end

#READ
  def self.find_by_id(id)
    sql = "SELECT * FROM films WHERE id = $1"
    values = [id]
    result = SqlRunner.run(sql, values).first
    return result
  end

#DELETE
  def self.delete_all()
    sql = "DELETE FROM films"
    SqlRunner.run(sql)
  end

end
