# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format
# (all these examples are active by default):
# ActiveSupport::Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end
#
ActiveSupport::Inflector.inflections do |inflect|
<<<<<<< HEAD
  inflect.uncountable %w(award_emoji project_statistics system_note_metadata event_log project_registry file_registry)
  inflect.acronym 'EE'
=======
  inflect.uncountable %w(
    award_emoji
    project_statistics
    system_note_metadata
    project_auto_devops
  )
>>>>>>> upstream/master
end
