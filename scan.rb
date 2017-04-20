# Scanner and Token code for ASSIGNMENT 8
# Code submission by SAURABH SETH

# kind method from Token class will return one of these lexical class value.
module LexicalClass
	EOF = "END OF LINE"
	ID = "IDENTIFIER"
	NUM = "NUMBER"
	EQUAL = "ASSIGN"
	LPAREN = "LEFT PARENTHESIS"
	RPAREN = "RIGHT PARENTHESIS"
	PLUS = "PLUS"
	MINUS = "MINUS"
	DIVIDE = "DIVIDE"
	MULTIPLY = "MULTIPLY"
	POWER = "POWER"
	CLEAR = "CLEAR"
	LIST = "LIST"
	QUIT = "QUIT"
	SQRT = "SQUARE ROOT"
	CBRT = "CUBE ROOT"
	SIN = "SINE"
	COS = "COSINE"
	TAN = "TANGENT"
	LOG = "LOGARITHM"
end

## TOKEN CLASS
class Token

	attr_accessor :type, :numVal, :idVal
	def initialize(type, numVal: nil, idVal: nil)
		@type = type
		if numVal
			@numVal = numVal
		end
		if idVal
			@idVal = idVal
		end
	end

	## Returns one of the lexical class set during initialize
	def kind
		return @type
	end

	def value
		if @type == LexicalClass::ID
			return @idVal
		elsif @type == LexicalClass::NUM
			return @numVal
		else
			return nil
		end
	end

	def to_s
		print "Token is of type :: " + self.kind + "."
		if @type == LexicalClass::ID
			print " Identifier has a name -- " + @idVal.to_s
		end
		if @type == LexicalClass::NUM
			print " Number has the value -- " + @numVal.to_s
		end
		print $/
	end

end


## SCANNER CLASS
class Scanner

	@@input_com = ""
	@@current_char_index = 0
	@@current_ch = ''
	@@keyword_table = {"clear"=>LexicalClass::CLEAR, "list"=>LexicalClass::LIST, 
		"exit"=>LexicalClass::QUIT, "quit"=>LexicalClass::QUIT, "sqrt"=>LexicalClass::SQRT,
		"cbrt"=>LexicalClass::CBRT, "sin"=>LexicalClass::SIN, "cos"=>LexicalClass::COS,
		"tan"=>LexicalClass::TAN, "log"=>LexicalClass::LOG
	}

	def initialize
		@@current_ch = nil
	end

	def input_statement(statement)
		@@input_com = statement.to_s
		@@current_char_index = 0
		@@current_ch = @@input_com[@@current_char_index]
    end

	def getNextCh
		@@current_char_index += 1
		if @@current_char_index == @@input_com.length
			@@current_ch = nil
		else
			@@current_ch = @@input_com[@@current_char_index]
		end
	end

	def next_token
		if @@current_ch == nil
			return Token.new(LexicalClass::EOF)
		end

		while @@current_ch == " "
			self.getNextCh
		end

		case @@current_ch
		when ";"
			self.getNextCh
			return Token.new(LexicalClass::EOF)
		when "="
			self.getNextCh
			return Token.new(LexicalClass::EQUAL)
		when "("
			self.getNextCh
			return Token.new(LexicalClass::LPAREN)
		when ")"
			self.getNextCh
			return Token.new(LexicalClass::RPAREN)
		when "+"
			self.getNextCh
			return Token.new(LexicalClass::PLUS)
		when "-"
			self.getNextCh
			return Token.new(LexicalClass::MINUS)
		when "/"
			self.getNextCh
			return Token.new(LexicalClass::DIVIDE)
		when "*"
			old_ch = @@current_ch
			self.getNextCh
			next_ch = @@current_ch
			if next_ch != nil
				if old_ch + next_ch == "**"
					self.getNextCh
					return Token.new(LexicalClass::POWER)
				else
					return Token.new(LexicalClass::MULTIPLY)
				end
			else
				return Token.new(LexicalClass::MULTIPLY)
			end
		when /[a-zA-Z]/
			id = @@current_ch
			while true
				self.getNextCh
				next_ch = @@current_ch
				if next_ch != nil
					if ((id + next_ch) =~ /\A[a-zA-Z][a-zA-Z0-9_]*\Z/)
						id += next_ch
					else
						break
					end
				else
					break
				end
			end
			
			if ["clear","list","quit","exit","sqrt","cbrt","sin","cos","tan","log"].include? id
				return self.getKeywordClass(id)
			end
			return Token.new(LexicalClass::ID, idVal: id)
		when /[0-9]/
			main_num = @@current_ch
			while true
				self.getNextCh
				next_ch = @@current_ch
				if next_ch != nil
					if next_ch =~ /[0-9]/
						main_num += next_ch
					elsif next_ch =~ /[.]/
						main_num += next_ch
						while true
							self.getNextCh
							next_ch = @@current_ch
							if next_ch =~ /[0-9]/
								main_num += next_ch
							else
								break
							end
						end
						break
					else
						break
					end
				else
					break
				end
			end

			if (main_num =~ /\A[0-9]+([.][0-9]+)?\Z/)
				if @@current_ch == 'e' or @@current_ch == 'E'
					main_num += @@current_ch
					self.getNextCh
					next_ch = @@current_ch
					if next_ch != nil
						if next_ch =~ /[+-]/
							main_num += next_ch
							self.getNextCh
							next_ch = @@current_ch
						end

						while (next_ch =~ /[0-9]/)
							main_num += next_ch
							self.getNextCh
							next_ch = @@current_ch
						end
					end

					if (main_num =~ /\A[0-9]+([.][0-9]+)?([eE][+-]?[0-9]+)?\Z/)
						return Token.new(LexicalClass::NUM, numVal: main_num.to_f) 
					else
						print "UNIDENTIFIED CHARACTER FOUND" + $/
						return self.next_token
					end

				else
					return Token.new(LexicalClass::NUM, numVal: main_num.to_f)
				end
			else
				print "UNIDENTIFIED CHARACTER FOUND" + $/
				return self.next_token
			end
		else
			print "UNIDENTIFIED CHARACTER FOUND" + $/
			self.getNextCh
			return self.next_token
		end
	end

	def getKeywordClass(keyword)
		return Token.new(@@keyword_table[keyword])
	end
end