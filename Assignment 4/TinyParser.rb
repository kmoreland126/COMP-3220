#
#  Parser Class
#
load "TinyToken.rb"
load "TinyLexer.rb"
class Parser < Lexer
	def initialize(filename)
    	@errors = 0
		super(filename)
    	consume()
   	end
   	
	def consume()
      	@lookahead = nextToken()
      	while(@lookahead.type == Token::WS)
        	@lookahead = nextToken()
      	end
   	end
  	
	def match(dtype)
      	if (@lookahead.type != dtype)
         	puts "Expected #{dtype} found #{@lookahead.text}"
			@errors += 1
      	end
      	consume()
   	end
   	
	def program()
      	while( @lookahead.type != Token::EOF)
        	puts "Entering STMT Rule"
			statement()  
      	end
		puts "There were #{@errors} parse errors found."
   	end

	def statement()
		if (@lookahead.type == Token::PRINT)
			puts "Found PRINT Token: #{@lookahead.text}"
			match(Token::PRINT)
			expression()
		else
			puts "Entering ASSGN Rule"
			assign()
		end
		puts "Exiting STMT Rule"
	end
	
	def assign()
		if (@lookahead.type == Token::ID)
			puts "Found ID Token: #{@lookahead.text}"
		end
		match(Token::ID)
		if (@lookahead.type == Token::ASSGN)
			puts "Found ASSGN Token: #{@lookahead.text}"
		end
		match(Token::ASSGN)
		expression()
		puts "Exiting ASSGN Rule"
	end

	def print()
		match(Token::PRINT)
		expression()
		puts "Exiting PRINT Rule"
	end

	def if_statement()
		match(Token::IFOP)
		condition()
		match(Token::THENOP)
		while(@lookahead.type != Token::ENDOP)
			statement()
		end
		match(Token::ENDOP)
		puts "Exiting IF Rule"
	end

	def while_statement()
		match(Token::WHILEOP)
		condition()
		match(Token::THENOP)
		while(@lookahead.type != Token::ENDOP)
			statement()
		end
		match(Token::ENDOP)
		puts "Exiting WHILE Rule"
	end

	def condition()
		puts "Entering CONDITION Rule"
		expression()
		match(Token::LT, Token::GT, Token::ANDOP)
		expression()
		puts "Exiting CONDITION Rule"
	end

	def expression()
		puts "Entering EXP Rule"
		term()
		etail()
		puts "Exiting EXP Rule"
	end

	def etail()
		puts "Entering ETAIL Rule"
		if (@lookahead.type == Token::ADDOP || @lookahead.type == Token::SUBOP)
			if (@lookahead.type == Token::ADDOP)
				puts "Found ADDOP Token: #{@lookahead.text}"
				match(Token::ADDOP)
			elsif @lookahead.type == Token::SUBOP
				puts "Found SUBOP Token: #{@lookahead.text}"
				match(Token::SUBOP)
			end
			term()
			etail()
		else
			puts "Did not find ADDOP or SUBOP Token, choosing EPSILON production"
		end
		puts "Exiting ETAIL Rule"
	end

	def term()
		puts "Entering TERM Rule"
		factor()
		ttail()
		puts "Exiting TERM Rule"
	end

	def ttail()
		puts "Entering TTAIL Rule"
		if (@lookahead.type == Token::MULTOP || @lookahead.type == Token::DIVOP)
			if (@lookahead.type == Token::MULTOP)
				puts "Found MULTOP Token: #{@lookahead.text}"
				match(Token::MULTOP)
			elsif (@lookahead.type == Token::DIVOP)
				puts "Found DIVOP Token: #{@lookahead.text}"
				match(Token::DIVOP)
			end
			factor()
			ttail()
		else
			puts "Did not find MULTOP or DIVOP Token, choosing EPSILON production"
		end
		puts "Exiting TTAIL Rule"
	end

	def factor()
		puts "Entering FACTOR Rule"
		if (@lookahead.type == Token::LPAREN)
			puts "Found LPAREN Token: #{@lookahead.text}"
			match(Token::LPAREN)
			expression()
			puts "Found RPAREN Token: #{@lookahead.text}"
			match(Token::RPAREN)
		elsif (@lookahead.type == Token::INT)
			puts "Found INT Token: #{@lookahead.text}"
			match(Token::INT)
        elsif (@lookahead.type == Token::ID)
            puts "Found ID Token: #{@lookahead.text}"
			match(Token::ID)
		else
			puts "Expected ( or INT or ID found #{@lookahead.text}"
			@errors += 1
			consume()
		end
		puts "Exiting FACTOR Rule"
	end
end
