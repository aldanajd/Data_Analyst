class Restaurant:
    def __init__(self, restaurant_name, cuisine_type):
        self.restaurant_name = restaurant_name
        self.cuisine_type = cuisine_type
    
    def describe_restaurant(self):
        print (("in " + self.restaurant_name + " you can now order " + self.cuisine_type).title())

    def open_restaurant(self):
        print ((self.restaurant_name + " is now open").title())


restaurant = Restaurant("Little Caesars", "Pizza")
restaurant_2 = Restaurant("Longhorn", "Steak")
restaurant_3 = Restaurant("Olive Garden", "Pasta")
restaurant.describe_restaurant()
restaurant.open_restaurant()
restaurant_2.open_restaurant()
restaurant_3.open_restaurant()

class User:
    def __init__(self, first_name, last_name, age, location):
        self.first_name = first_name; self.last_name = last_name; self.age = age; self.location = location 

    def describe_user(self):
        print (("first Name: %s \nlast Name: %s\nage: %d \nlocation: %s" % (self.first_name, self.last_name, self.age, self.location)).title())
    
    def greet_user(self):
        print (("hello %s %s !" % (self.first_name, self.last_name)).title())

user_1, user_2, user_3 = User("jorge", "aldana", 26, "bradenton"), User("narly", "aldana", 30, "bradenton"), User("nayla", "aldana", 34, "queretaro")

user_1.describe_user(), user_1.greet_user(), user_2.describe_user(), user_2.greet_user(), user_3.describe_user(), user_3.greet_user()