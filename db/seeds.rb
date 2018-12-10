# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

a = Account.create!(name: 'Acme Corporation')
User.create!(login: 'seller', account: a)

# Product belongs to account, user, set in the Product#before_validation
RequestRegistry.current_user = User.first
RequestRegistry.current_account = User.first.account

# Load fixtures
Dir[File.join(Rails.root, 'test', 'fixtures', 'files').to_s + '/*'].each do |file|

  Amazon::ProductParser.new(
    IO.readlines(file).join,
    File.basename(file)
  ).product.save!
end
