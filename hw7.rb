## HW 7B Submission by Saurabh Seth

# readline provides nice command-line editing for text input
require 'readline'
require_relative 'scan'

def prompt(text="")
    if text != ""
        puts text
    end
    return Readline::readline("calculator > ", true).strip
end

def main_loop()
    until false do
        inp = prompt
        if inp != nil and inp != ""
        	args = inp.split(" ")
	        end_calc = args[0].downcase

	        if (end_calc == 'quit' or end_calc == 'exit')
	        	puts "Quitting...."
	            break
	        end
        	scan_input(inp)
        end
    end
end

def scan_input(args)
	scanner = Scanner.new
	scanner.input_statement(args)
	i = 0
	while true
		token = scanner.next_token
		i = i+1
		print i.to_s + " :: "
		print token.to_s
		if token.kind == LexicalClass::EOF
			break
		end
	end
end

puts "How can I help you with your calculations today??"
main_loop