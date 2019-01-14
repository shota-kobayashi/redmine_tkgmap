require_dependency 'custom_fields_helper'

module CustomFieldsHelperPatch
	def self.included(base)
		base.send(:prepend, InstanceMethods)
	end

	module InstanceMethods
		def custom_field_tag(name, custom_value)
			
			custom_field = custom_value.custom_field
			field_format = Redmine::FieldFormat.find(custom_field.field_format)
			if field_format.format_name == "tkg"
				s = super(name, custom_value)
				windowWidth = Setting.plugin_redmine_tkgmap['map_width'].to_i + 30
				windowHeight = Setting.plugin_redmine_tkgmap['map_height'].to_i + 30
				customFieldId = "#{name}_custom_field_values_#{custom_field.id}"
				s << javascript_include_tag('showMapWindow',:plugin => 'redmine_tkgmap')
				s << content_tag("input", "", {:type => 'button', :onClick =>"showMapWindow(\"#{url_for(:controller => 'tkgmap', :action => 'window')}\", \"#{customFieldId}\", #{windowWidth}, #{windowHeight});", :value=>l(:set_lat_lng_tkg)})
			else
				s = super(name, custom_value)
			end
		end
	end
end

CustomFieldsHelper.send(:include, CustomFieldsHelperPatch)
