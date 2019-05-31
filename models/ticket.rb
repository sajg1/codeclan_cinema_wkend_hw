require_relative('../db/sql_runner')
require_relative('film')
require_relative('customer')

class Ticket

  attr_reader :id
  attr_accessor :customer_id, :film_id

  def initialize(options)
    @customer_id = options['customer_id'].to_i
    @film_id = options['film_id'].to_i
    @id = options['id'].to_i if options['id']
  end

#CREATE
  def save()
    sql = "INSERT INTO tickets
    (
      customer_id, film_id
    )
    VALUES
    (
      $1, $2
    ) RETURNING id"
    values = [@customer_id, @film_id]
    result = SqlRunner.run(sql, values).first
    @id = result['id'].to_i
  end

#UPDATE
  def update()
    sql = "UPDATE tickets SET
    (
      customer_id, film_id
    )
    =
    (
      $1, $2
    )
    WHERE id = $3"
    values = [@customer_id, @film_id, @id]
    SqlRunner.run(sql, values)
  end

#DELETE
  def delete()
    sql = "DELETE FROM tickets WHERE id = $1"
    values =[@id]
    SqlRunner.run(sql, values)
  end



#READ

  def self.all()
    sql = "SELECT * FROM tickets"
    tickets = SqlRunner.run(sql)
    return tickets.map {|ticket| Ticket.new(ticket)}
  end

#DELETE
  def self.delete_all()
    sql = "DELETE FROM tickets"
    SqlRunner.run(sql)
  end

#READ
  def self.find_by_id(id)
    sql = "SELECT * FROM tickets WHERE id = $1"
    values = [id]
    result = SqlRunner.run(sql, values).first
    return Ticket.new(result)
  end




end
