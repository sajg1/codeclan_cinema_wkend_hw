require_relative('../db/sql_runner')
require_relative('film')
require_relative('ticket')

class Customer

  attr_reader :id
  attr_accessor :name, :funds

  def initialize(options)
    @name = options['name']
    @funds = options['funds'].to_i
    @id = options['id'] if options['id']
    @tickets = []
  end

#CREATE
  def save()
    sql = "INSERT INTO customers
    (
      name, funds
    )
    VALUES
    (
      $1, $2
    ) RETURNING id"
    values = [@name, @funds]
    result = SqlRunner.run(sql, values).first
    @id = result['id'].to_i
  end

#UPDATE
  def update()
    sql = "UPDATE customers SET
    (
      name, funds
    )
    =
    (
      $1, $2
    ) WHERE id = $3"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

#DELETE
  def delete()
    sql = "DELETE FROM customers WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

#READ
  def films()
    sql = "SELECT films.* FROM films
    INNER JOIN tickets
    ON tickets.film_id = films.id
    WHERE customer_id = $1"
    values = [@id]
    films = SqlRunner.run(sql, values)
    return films.map {|film| Film.new(film)}
  end

  def buy_ticket(film)
    return if @funds < film.price
    ticket = Ticket.new({'customer_id' => @id, 'film_id' => film.id})
    ticket.save()
    @funds -= film.price
    update()
    tickets = []
    @tickets << ticket
  end

  def tickets_bought()
    @tickets.count
  end

# First attempt at buy_ticket
  #   # sql = "SELECT films.price FROM films
  #   # INNER JOIN tickets
  #   # ON tickets.film_id = films.id
  #   # WHERE customer_id = $1;"
  #   sql = "SELECT price FROM films
  #   WHERE id = $1"
  #   values = [film.id]
  #   # values = [@id]
  #   film_price_hash = SqlRunner.run(sql, values).first
  #   film_price = film_price_hash['price'].to_i
  #   return "Sorry, thats not enough" if @funds < film_price
  #   @funds -= film_price
  #   return "You have paid for the film. Your new balance is #{@funds}"
  # end



#READ
  def self.all()
    sql = "SELECT * FROM customers"
    customers = SqlRunner.run(sql)
    return customers.map {|customer| Customer.new(customer)}
  end

#READ
  def self.find_by_id(id)
    sql = "SELECT * FROM customers WHERE id = $1"
    values = [id]
    result = SqlRunner.run(sql, values).first
    return Customer.new(result)
  end

#DELETE
  def self.delete_all()
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end


end
