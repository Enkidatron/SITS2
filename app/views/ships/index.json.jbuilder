json.array!(@ships) do |ship|
  json.extract! ship, :id, :name, :class, :pivot, :roll, :notes
  json.url ship_url(ship, format: :json)
end
