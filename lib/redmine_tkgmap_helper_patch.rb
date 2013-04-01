require_dependency 'custom_fields_helper'

module RedmineTkgmapHelperPatch
    def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
            unloadable

            alias_method_chain :custom_field_tag, :extended
        end
    end

		module InstanceMethods
        def custom_field_tag_with_extended(name, custom_value)
            custom_field = custom_value.custom_field
            field_name   = "#{name}[custom_field_values][#{custom_field.id}]"
            field_id     = "#{name}_custom_field_values_#{custom_field.id}"
            field_title  = custom_field.name.gsub(%r{[^a-z0-9_]+}i, '_').downcase
            field_class  = (field_title =~ %r{[a-z0-9]+}i) ? "#{name}_custom_field_values_#{field_title}" : field_id
            field_format = Redmine::CustomFieldFormat.find_by_name(custom_field.field_format)
            case field_format.try(:edit_as)
            when 'string', 'link'
                tag = text_field_tag(field_name, custom_value.value, :id => field_id, :class => field_class)
            when 'project'
                blank = custom_field.is_required? ?
                      ((custom_field.default_value.blank? && custom_value.value.blank?) ? content_tag(:option, "--- #{l(:actionview_instancetag_blank_option)} ---") : ''.html_safe) :
                        content_tag(:option)
                tag = select_tag(field_name,
                                 blank + options_for_select(custom_field.possible_values_options(custom_value.customized), custom_value.value),
                                 :id => field_id, :class => field_class)
            else
                tag = custom_field_tag_without_extended(name, custom_value)
            end

            unless custom_field.hint.blank?
                tag << tag(:br)
                tag << content_tag(:em, h(custom_field.hint))
            end

            tag
        end


		end

end
