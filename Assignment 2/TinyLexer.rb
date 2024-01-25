#
#  Class Lexer - Reads a TINY program and emits tokens
#
class Lexer
# Constructor - Is passed a file to scan and outputs a token
#               each time nextToken() is invoked.
#   @c        - A one character lookahead 
	def initialize(filename)
		begin
			@f = File.open(filename,'r:utf-8')
		# Need to modify this code so that the program
		# doesn't abend if it can't open the file but rather
		# displays an informative message
		
		# Go ahead and read in the first character in the source
		# code file (if there is one) so that you can begin
		# lexing the source code file 
			if (! @f.eof?)
				@c = @f.getc()
			else
				@c = "eof"
				@f.close()
			end
		rescue Errno::ENOENT
			puts "Could not open file: #{filename}"
			@c = "eof"
		end
	end
	
	# Method nextCh() returns the next character in the file
	def nextCh()
		if (! @f.eof?)
			@c = @f.getc()
		else
			@c = "eof"
		end
		
		return @c
	end

	# Method nextToken() reads characters in the file and returns
	# the next token
	def nextToken() 
		if @c == "eof"
			tok = Token.new(Token::EOF,"eof")
		elsif (whitespace?(@c))
			str =""
			while whitespace?(@c)
				str += @c
				nextCh()
			end
			tok = Token.new(Token::WS,str)
		elsif (numeric?(@c))
			num = ""
			while numeric?(@c)
				num += @c
				nextCh()
			end
			tok = Token.new(Token::INTNUM,num)
		elsif (letter?(@c))
			str = ""
			while letter?(@c)
				str += @c
				nextCh()
			end
			tok_type = Token::ID
			if str == "print"
				tok_type = Token::PRINT
			end
			tok = Token.new(tok_type,str)
		elsif (@c == ";")
			puts "Current charcater: #{@c}"
			nextCh()
			tok = Token.new(Token::SEMICOLON,";")
			puts "Current token: #{tok}"
		elsif (@c == "!")
			puts "Current charcater: #{@c}"
			nextCh()
			tok = Token.new(Token::EXCLAMATION,"!")
			puts "Current token: #{tok}"
		elsif (@c == "+")
			puts "Current charcater: #{@c}"
			nextCh()
			tok = Token.new(Token::ADDOP,"+")
			puts "Current token: #{tok}"
		elsif (@c == "-")
			nextCh()
			tok = Token.new(Token::SUBOP,"-")
		elsif (@c == "*")
			nextCh()
			tok = Token.new(Token::MULTOP,"*")
		elsif (@c == "/")
			nextCh()
			tok = Token.new(Token::DIVOP,"/")
		elsif (@c == "(")
			nextCh()
			tok = Token.new(Token::LPAREN,"(")
		elsif (@c == ")")
			nextCh()
			tok = Token.new(Token::RPAREN,")")
		elsif (@c == "<")
			nextCh()
			tok = Token.new(Token::LESS_THAN,"<")
		elsif (@c == ">")
			nextCh()
			tok = Token.new(Token::GREATER_THAN,">")
		elsif (@c == "&")
			nextCh()
			tok = Token.new(Token::AND,"&")
		# elsif ...
		# more code needed here! complete the code here 
		# so that your scanner can correctly recognize,
		# print (to a text file), and display all tokens
		# in our grammar that we found in the source code file
		
		# FYI: You don't HAVE to just stick to if statements
		# any type of selection statement "could" work. We just need
		# to be able to programatically identify tokens that we 
		# encounter in our source code file.
		
		# don't want to give back nil token!
		# remember to include some case to handle
		# unknown or unrecognized tokens.
		# below is an example of how you "could"
		# create an "unknown" token directly from 
		# this scanner. You could also choose to define
		# this "type" of token in your token class
		elsif (@c == "i")
			nextCh()
			if (@c == "f")
				nextCh()
				tok = Token.new(Token::IF,"if")
			end
		elsif (@c == "t")
			nextCh()
			if (@c == "h")
				nextCh()
				if (@c == "e")
					nextCh()
					if (@c == "n")
						nextCh()
						tok = Token.new(Token::THEN,"then")
					end
				end
			end
		elsif (@c == "w")
			nextCh()
			if (@c == "h")
				nextCh()
				if (@c == "i")
					nextCh()
					if (@c == "l")
						nextCh()
						if (@c == "e")
							nextCh()
							tok = Token.new(Token::WHILE,"while")
						end
					end
				end
			end
		else
			tok = Token.new(Token::UNKWN,@c)
			nextCh()
		end
		return tok
	end
end
#
# Helper methods for Scanner
#
def letter?(lookAhead)
		lookAhead =~ /^[a-z]|[A-Z]$/
end

def numeric?(lookAhead)
		lookAhead =~ /^(\d)+$/
end

def whitespace?(lookAhead)
		lookAhead =~ /^(\s)+$/
end
