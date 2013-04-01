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
			s = custom_field_tag_without_tkg(name, custom_value)
			s << aaa
			s
		end

		def aaa
			"aaa"
		end
	end
end

CustomFieldsHelper.send(:include, CustomFieldsHelperPatch)
