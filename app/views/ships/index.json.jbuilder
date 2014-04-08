json.array!(@ships) do |ship|
  json.extract! ship, :id, :name, :ship_class, :pivot, :roll, :notes, :user_id
  json.url ship_url(ship, format: :json)
end
