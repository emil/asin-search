# Original from http://snippets.dzone.com/posts/show/4468 by MichaelBoutros
#
# Optimized version which uses to_yaml for content creation and checks
# that models are ActiveRecord::Base models before trying to fetch
# them from database.
namespace :db do
  namespace :fixtures do
    desc 'Dumps all models into fixtures.'
    task :dump => :environment do
      Rails.application.eager_load!

      models = ApplicationRecord.descendants

      puts "Found models: " + models.join(', ')

      models.each do |m|
        puts "Dumping model: " + m.to_s
        entries = m.order(id: :asc).all

        increment = 1

        model_file = "#{Rails.root}/test/fixtures/#{m.to_s.underscore.pluralize}.yml"
        File.open(model_file, 'w') do |f|

          f << entries.inject({}) do |h,a|
            attrs = a.attributes_before_type_cast
            attrs.delete_if{|k,v| v.blank?}

            h[m.to_s + '_' + increment.to_s] = attrs

            increment += 1
            h
          end.to_yaml
          
        end
      end
    end
  end
end
