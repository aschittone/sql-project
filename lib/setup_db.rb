require "sqlite3"
require 'csv'
require 'pry'

@db = SQLite3::Database.new "./db/daily_show.db"

years_table =
  "CREATE TABLE IF NOT EXISTS years (
    id INTEGER PRIMARY KEY,
    year INTEGER
  );"

episode_table =
  "CREATE TABLE IF NOT EXISTS episodes (
    id INTEGER PRIMARY KEY,
    year_id INTEGER,
    date TEXT
  );"

guest_table =
  "CREATE TABLE IF NOT EXISTS guests (
    id INTEGER PRIMARY KEY,
    name TEXT,
    occupation TEXT,
    industry TEXT
  );"

episode_guests =
  "CREATE TABLE IF NOT EXISTS episode_guests (
    id INTEGER PRIMARY KEY,
    episode_date TEXT,
    guest_id INTEGER
  );"

@db.execute(years_table)
@db.execute(episode_table)
@db.execute(guest_table)
@db.execute(episode_guests)

years = []
data = []
guests = []

CSV.foreach("./data/daily_show_guests.csv", headers: true) do |row|
   years << row[0]
   data << row
   guests.push([row[1], row[3], row[4]])
end

unique_years = years.uniq
unique_years.each do |year|
  @db.execute("INSERT INTO years (year) VALUES (?)", year)
end

guest_ids = Hash.new()

guests.uniq.each do |guest_info|
  name = guest_info[2]
  occupation = guest_info[0]
  industry = guest_info[1]
  @db.execute("INSERT INTO guests (name, occupation, industry) VALUES (?, ?, ?)", name, occupation, industry)
  guest_ids[name] = @db.last_insert_row_id
end

guest_episodes = Hash.new()
data.each do |row|
  date = row[2]
  name_in_data = row[4]
  guest_episodes[date] ||= []
  guest_episodes[date] << guest_ids[name_in_data]
end

data.each do |episode|
  date = episode[2]
  new_date = date.split("").last(2).join("")
  unique_years.each do |year|
    new_year = year.split("").last(2).join("")
    id_for_year = unique_years.index(year) + 1
    if new_date == new_year
      @db.execute("INSERT INTO episodes (year_id, date) VALUES (?, ?)", id_for_year, date)
    end
  end
end

guest_episodes.each do |episode, guests|
  guests.each do |guest|
    @db.execute("INSERT INTO episode_guests (episode_date, guest_id) VALUES (?, ?)", episode, guest)
  end
end
