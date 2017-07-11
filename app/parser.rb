require "sqlite3"
require 'csv'
require 'pry'

db = SQLite3::Database.new ":memory:"

years_table =
  "CREATE table years (
    id INTEGER PRIMARY KEY,
    year INTEGER
  );"

episode_table =
  "CREATE table episodes (
    id INTEGER PRIMARY KEY,
    year_id INTEGER,
    date TEXT,
    guest_id INTEGER
  );"

guest_table =
  "CREATE table guests (
    id INTEGER PRIMARY KEY,
    name TEXT,
    occupation TEXT,
    industry TEXT,
    episode_id INTEGER
  );"

db.execute(years_table)
db.execute(episode_table)
db.execute(guest_table)


years = []
data = []
guests = []

CSV.foreach("./config/daily_show_guests.csv", headers: true) do |row|
   years << row[0]
   data << row
   guests.push([row[1], row[3], row[4]])
  #   db.execute("INSERT INTO episodes SELECT id FROM years WHERE years. (?, ?)", episode[0])
  #   db.execute("INSERT INTO years (year) VALUES (?)", episode[0])
  #   db.execute("INSERT INTO years (year) VALUES (?)", episode[0])
end
unique_years = years.uniq
unique_years.each do |year|
  db.execute("INSERT INTO years (year) VALUES (?)", year)
end

guests.each do |guest_info|
  name = guest_info[2]
  occupation = guest_info[0]
  industry = guest_info[1]
  db.execute("INSERT INTO guests (name, occupation, industry, episode_id) VALUES (?, ?, ?, ?)", name, occupation, industry, nil)
end

data.each do |episode|
  date = episode[2]
  new_date = date.split("").last(2).join("")
  unique_years.each do |year|
    new_year = year.split("").last(2).join("")
    id_for_year = unique_years.index(year) + 1
    if new_date == new_year
      db.execute("INSERT INTO episodes (year_id, date, guest_id) VALUES (?, ?, ?)", id_for_year, date, nil)
    end
  end
end

# ASK ABOUT THIS TOMORROW- ADDING IN EPISODE AND GUEST IDS TO GUESTS AND EPISODE TABLES

episode_ids = db.execute("SELECT id FROM episodes")
guest_ids = db.execute("SELECT id FROM guests")

episode_ids.each do |id|
  db.execute("UPDATE guests SET episode_id = #{id} WHERE guest.id = guest")
end
# binding.pry

Pry.start
# CSV.foreach("./config/daily_show_guests.csv", headers: true) do |row|
#
#   db.execute("INSERT INTO episodes (guest_id) VALUES (?)", )
#   db.execute("INSERT INTO episode_guests (episode_id, guest_id) SELECT id FROM episodes WHERE ")
# end












# data.each do |episode|
#  db.execute "insert into guests values ( ? )", guest
# end

# ... do more stuff
