require_dependency 'custom_fields_helper'

module CustomFieldsHelperPatch
	def self.included(base)
		base.send(:include, InstanceMethods)
		base.class_eval do
			alias_method_chain :custom_field_tag, :tkg
		end
	end

	module InstanceMethods
		def custom_field_tag_with_tkg(name, custom_value)
			
	    custom_field = custom_value.custom_field
			field_format = Redmine::CustomFieldFormat.find_by_name(custom_field.field_format)
			if field_format.try(:edit_as) == "tkg"
				s = custom_field_tag_without_tkg(name, custom_value)
				windowWidth = Setting.plugin_redmine_tkgmap['map_width'].to_i + 30
				windowHeight = Setting.plugin_redmine_tkgmap['map_height'].to_i + 30
				customFieldId = "issue_custom_field_values_" + custom_field.id.to_s

				s << javascript_include_tag('showMapWindow',:plugin => 'redmine_tkgmap')
				s << content_tag("input", "", {:type => 'button', :onClick =>"showMapWindow(\"/redmine/tkgmap/window\", \"#{customFieldId}\", #{windowWidth}, #{windowHeight});", :value=>l(:set_lat_lng_tkg)})
			else
				s = custom_field_tag_without_tkg(name, custom_value)
			end
		end
	end
end

CustomFieldsHelper.send(:include, CustomFieldsHelperPatch)
