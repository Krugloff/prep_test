# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

%w[silver gold].each do |band_name|
  band = Band.find_or_create_by!(name: "ruby/#{band_name}/v3")

  path = Rails.root.join("db/seeds/questions/ruby/#{band_name}/v3/en")
  dirs = Dir.glob(path.join('**')).sort_by { _1.scan(/\d+/).last.to_i }

  dirs.each do |path|  
    text = File.read(path)
    # scan = text.match(/## title(?<title>.*)(## body(?<body>.*))?## options(?<opts>.*)## comment(?<comment>.*)/m)

    scan = text
      .split(/^(## title)|(## body)|(## options)|(## comment)$/)
      .slice(1..-1)
      .map { _1.sub(/^## /, '') }
      .each_slice(2)
      .to_h

    title = scan['title'].to_s.strip
    body = scan['body'].to_s.strip
    comment = scan['comment'].strip

    enemy = 
      Enemy.find_or_create_by!(title:, body:, comment:, band_id: band.id, language: 'en')

    scan = scan['options'].strip.split(/### (?<name>[A-Z][+]?)\s+/m).select(&:present?)
    scan.each_slice(2) do |pair|
      name = pair.first[/[a-z]/i]
      correct = pair.first.end_with?(?+)
      body = pair.last.strip

      Puppet.find_or_create_by!(name:, body:, enemy:, correct:)
    end
  end

  Ring.find_or_create_by!(band_id: band.id, maximum_score: 50)
end