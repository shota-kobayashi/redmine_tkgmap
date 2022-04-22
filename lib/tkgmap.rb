class Tkgmap < Redmine::FieldFormat::Unbounded
	add 'tkg'
	Identifier = "tkg"
	
	def format_name
	 "tkg"
	end
	
	def label
	 "label_tkg"
	end
	
	def format_as_tkg(value)
		value
	end
end
Redmine::FieldFormat.add 'tkg', Tkgmap
