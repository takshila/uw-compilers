# Calculator code for ASSIGNMENT 8
# Code submission by SAURABH SETH

require 'readline'
require_relative 'scan'

class Parser

	## id_map to store identifiers and their data
	@@id_map={"PI"=>Math::PI}
	@@scanner = nil
	@@token = nil
	@@next_token = nil

	def initialize
		@@scanner = $scanner
	end

	def getNextToken
		if @@next_token != nil
			@@token = @@next_token
			@@next_token = @@scanner.next_token
		else
			@@token = @@scanner.next_token
			@@next_token = @@scanner.next_token
		end
	end

	def program
		@@next_token = nil
		result = self.statement
		if result == 'QUIT'
    		return result
    	end
		while @@next_token.kind != LexicalClass::EOF
			result = self.statement
			if result == 'QUIT'
	    		return result
	    	end
	    end
	end

	def statement
		self.getNextToken

		case @@token.kind
		when LexicalClass::QUIT
			return 'QUIT'
		when LexicalClass::LIST
			self.listStmt
		when LexicalClass::CLEAR
			self.clearStmt
		when LexicalClass::ID
			if @@next_token.kind == LexicalClass::EQUAL
				self.assignStmt(@@token.value)
			else
				data = self.exp
				if data != nil
					print data.to_s + $/
				else
					print "INCORRECT SYNTAX. PLEASE CHECK THE MANUAL." + $/
				end
			end
		else
			data = self.exp
			if data != nil
				print data.to_s + $/
			else
				print "INCORRECT SYNTAX. PLEASE CHECK THE MANUAL." + $/
			end
		end

		if @@token.kind != LexicalClass::EOF
			print "JUNK PRESENT IN THE INPUT." + $/
		end
	end

	def listStmt
		@@id_map.each do |key, value|
			print key.to_s
			i = key.length
			while i < 15
				i += 1
				print " "
			end
			print " -->  "
			print value.to_s + $/
		end
		self.getNextToken
	end


	def clearStmt
		self.getNextToken
		if @@token.kind != LexicalClass::ID
			print "ERROR IN SYNTAX. AN IDENTIFIER EXPECTED AFTER clear." + $/
		else
			id = @@token.value
			if @@id_map.has_key? id
				@@id_map.delete(id)
				print id + " erased successfully from the memory." + $/
			else
				print "UNKNOWN IDENTIFIER --> " + id + ". " + $/
			end
		end
		self.getNextToken
	end

	def assignStmt(id)
		self.getNextToken
		## current token -- EQUAL
		self.getNextToken
		data = self.exp
		if data != nil
			@@id_map.merge!(id => data)
			print id + " saved to memory as " + data.to_s + $/
		else
			print "INCORRECT INPUT. PLEASE CHECK THE MANUAL." + $/
		end
	end

	def exp
		data = self.term
		if data == nil
			return nil
		end

		while true
			if @@token.kind == LexicalClass::PLUS
				self.getNextToken
				new_data = self.term
				if new_data == nil
					return nil
				end
				data += new_data
			elsif @@token.kind == LexicalClass::MINUS
				self.getNextToken
				new_data = self.term
				if new_data == nil
					return nil
				end
				data -= new_data
			else
				break
			end
		end

		return data
	end

	def term
		data = self.power
		if data == nil
			return nil
		end

		while true
			if @@token.kind == LexicalClass::MULTIPLY
				self.getNextToken
				new_data = self.power
				if new_data == nil
					return nil
				end
				data *= new_data
			elsif @@token.kind == LexicalClass::DIVIDE
				self.getNextToken
				new_data = self.power
				if new_data == 0
					print "DIVISION BY ZERO NOT ALLOWED. "
					return nil
				elsif new_data == nil
					return nil
				end
				data /= new_data
			else
				break
			end
		end
		return data
	end

	def power
		data = self.factor
		if data == nil
			return nil
		end

		while@@token.kind == LexicalClass::POWER
			self.getNextToken
			new_data = self.power
			if new_data == nil
				return nil
			end
			data = data ** new_data
		end

		return data
	end

	def factor
		case @@token.kind
		when LexicalClass::NUM
			data = @@token.value
			self.getNextToken
			return data
		when LexicalClass::ID
			return self.get_id_value
		when LexicalClass::LPAREN
			return self.exp_parenthesis
		when LexicalClass::SQRT
			self.getNextToken
			## current token --> Left paren
			data = self.exp_parenthesis
			if data == nil
				return nil
			end
			return Math.sqrt(data)
		when LexicalClass::MINUS
			self.getNextToken
			if @@token.kind == LexicalClass::LPAREN
				data = self.exp_parenthesis
			elsif @@token.kind == LexicalClass::NUM
				data = @@token.value
				self.getNextToken
			else
				data = nil
			end

			if data == nil
				return nil
			end
			return -1*data
		when LexicalClass::CBRT
			self.getNextToken
			## current token --> Left paren
			data = self.exp_parenthesis
			if data == nil
				return nil
			end
			return Math.cbrt(data)
		when LexicalClass::SIN
			self.getNextToken
			## current token --> Left paren
			data = self.exp_parenthesis
			if data == nil
				return nil
			end
			return Math.sin(data)
		when LexicalClass::COS
			self.getNextToken
			## current token --> Left paren
			data = self.exp_parenthesis
			if data == nil
				return nil
			end
			return Math.cos(data)
		when LexicalClass::TAN
			self.getNextToken
			## current token --> Left paren
			data = self.exp_parenthesis
			if data == nil
				return nil
			end
			return Math.tan(data)
		when LexicalClass::LOG
			self.getNextToken
			## current token --> Left paren
			data = self.exp_parenthesis
			if data == nil
				return nil
			end
			return Math.log(data)
		else
			return nil
		end
	end

	def get_id_value
		id = @@token.value
		if @@id_map.has_key? id
			data = @@id_map[id]
			self.getNextToken
			return data
		else
			print "UNKNOWN IDENTIFIER --> " + id + ". "
			self.getNextToken
			return nil
		end
	end

	def exp_parenthesis
		if @@token.kind != LexicalClass::LPAREN
			print "MISSING ( IN THE EXPRESSION. "
			return nil
		end
		self.getNextToken
		data = self.exp
		if data == nil
			return nil
		end
		## current token --> Right paren
		if @@token.kind != LexicalClass::RPAREN
			print "MATCHING ) NOT FOUND FOR (. "
			return nil
		end
		self.getNextToken
		return data
	end

end


def prompt(text="")
    if text != ""
        puts text
    end
    return Readline::readline("calculator > ", true).strip
end

def main_loop
	$scanner = Scanner.new
	$parser = Parser.new
    until false do
        inp = prompt
        if inp != nil and inp != ""
        	$scanner.input_statement(inp)
        	result = $parser.program

        	if result == 'QUIT'
        		print 'Quitting....' + $/
        		break
        	end
        end
    end
end

puts "How can I help you with your calculations today??"
main_loop