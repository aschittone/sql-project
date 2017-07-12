require_relative 'setup_db.rb'

######################################################################
# QUERIES:

def select_guest_from_episode(episode) # ENTER IN EPISODE AS STRING, M/DD/YY
  @db.execute("SELECT guests.name FROM guests JOIN episode_guests ON episode_guests.guest_id = guests.id WHERE episode_guests.episode_date = ? LIMIT 1", episode)
end

def popular_guest_occupation
  @db.execute("SELECT occupation FROM guests GROUP BY occupation ORDER BY COUNT(*) DESC LIMIT 1")
end

def guest_with_most_appearances
  @db.execute("SELECT guests.name FROM guests JOIN episode_guests ON guests.id = episode_guests.guest_id GROUP BY episode_guests.guest_id ORDER BY COUNT(*) DESC LIMIT 1")
end

def average_num_of_guests_per_year
  @db.execute("SELECT COUNT(guest_id)/(SELECT COUNT(year) FROM years) FROM episode_guests")
end

def guests_by_occupation(occupation) # ENTER IN AS STRING
  @db.execute("SELECT guests.name FROM guests WHERE occupation = ?", occupation)
end

Pry.start
