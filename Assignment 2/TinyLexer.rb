#
#  Class Lexer - Reads a TINY program and emits tokens
#
class Lexer
    # Constructor - Is passed a file to scan and outputs a token
    #               each time nextToken() is invoked.
    #   @c        - A one character lookahead 
        def initialize(filename)
            # Need to modify this code so that the program
            # doesn't abend if it can't open the file but rather
            # displays an informative message
            @f = File.open(filename,'r:utf-8')
            
            # Go ahead and read in the first character in the source
            # code file (if there is one) so that you can begin
            # lexing the source code file 
            if (! @f.eof?)
                @c = @f.getc()
            else
                @c = "eof"
                @f.close()
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
                return Token.new(Token::EOF,"eof") 

            elsif (whitespace?(@c))
                str =""

                while whitespace?(@c)
                    str += @c
                    nextCh()
                end

                tok = Token.new(Token::WS,str)
                return tok
            elsif(letter?(@c))
                str = ""
                while letter?(@c)
                    str += @c
                    nextCh()
                end
                if str == "end"
                    tok = Token.new(Token::END_KEYWORD,str)
                    return tok
                else
                    tok = Token.new(Token::ID,str)
                    return tok
                end
            elsif (numeric?(@c))
                str = ""
                while numeric?(@c)
                    str += @c
                    nextCh()
                end
                tok = Token.new(Token::INT,str)
                return tok
            elsif(@c == '+')
                nextCh()
                tok = Token.new(Token::ADDOP,'+')
                return tok
            elsif(@c == '-')
                nextCh()
                tok = Token.new(Token::SUBOP,'-')
                return tok
            elsif(@c == '*')
                nextCh()
                tok = Token.new(Token::MULTOP,'*')
                return tok
            elsif(@c == '/')
                nextCh()
                tok = Token.new(Token::DIVOP,'/')
                return tok
            elsif(@c == '=')
                nextCh()
                tok = Token.new(Token::EQOP,'=')
                return tok
            elsif(@c == '(')
                nextCh()
                tok = Token.new(Token::LPAREN,'(')
                return tok
            elsif(@c == ')')
                nextCh()
                tok = Token.new(Token::RPAREN,')')
                return tok
            elsif(@c == ':')
                nextCh()
                if(@c == '=')
                    nextCh()
                    tok = Token.new(Token::ASSIGN,':=')
                    return tok
                end
            else
                tok = Token.new(Token::UNKWN,@c)
                nextCh()
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
end
