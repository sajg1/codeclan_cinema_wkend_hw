require_relative('../models/customer')
require_relative('../models/film')
require_relative('../models/ticket')
require('pry-byebug')

Customer.delete_all()
Film.delete_all()

customer1 = Customer.new({'name' => 'Steve', 'funds' => '50'})
customer2 = Customer.new({'name' => 'Roisin', 'funds' => '10'})

customer1.save()
customer2.save()

film1 = Film.new({'title' => 'Aladdin', 'price' => '5'})

film1.save()

ticket1 = Ticket.new({'customer_id' => customer1.id, 'film_id' => film1.id})
ticket2 = Ticket.new({'customer_id' => customer2.id, 'film_id' => film1.id})





binding.pry
nil
