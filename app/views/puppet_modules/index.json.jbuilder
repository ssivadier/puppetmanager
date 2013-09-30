json.array!(@puppet_modules) do |puppet_module|
  json.extract! puppet_module, :name, :version
  json.url puppet_module_url(puppet_module, format: :json)
end
