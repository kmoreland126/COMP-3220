#
#  Parser Class
#
load "TinyLexer.rb"
load "TinyToken.rb"
load "AST.rb"

class Parser < Lexer

    def parse
        root = program()
        root = root.reverse_subtree()
        return root
    end

    def initialize(filename)
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
			@errors_found+=1
        end
        consume()
    end

    def program()
    	@errors_found = 0
		
		p = AST.new(Token.new("program","program"))
		
	    while( @lookahead.type != Token::EOF)
            p.addChild(statement())
        end
        
        puts "There were #{@errors_found} parse errors found."
      
		return p
    end

    def statement()
		stmt = nil
        if (@lookahead.type == Token::PRINT)
			stmt = AST.new(@lookahead)
            match(Token::PRINT)
            stmt.addChild(exp())
        else
            stmt = assign()
        end
		return stmt
    end

    def exp()
        node = term()
        return etail(node)
    end

    def term()
        node = factor()
        ttail(node)
    end

    def factor()
        if (@lookahead.type == Token::LPAREN)
            match(Token::LPAREN)
            node = exp()
            match(Token::RPAREN)
            return node
        elsif (@lookahead.type == Token::INT)
            fct = AST.new(@lookahead)
            match(Token::INT)
            return fct
        elsif (@lookahead.type == Token::ID)
            fct = AST.new(@lookahead)
            match(Token::ID)
            return fct
        else
            puts "Expected ( or INT or ID found #{@lookahead.text}"
            @errors_found+=1
            consume()
        end
    end

    def ttail(node)
        if (@lookahead.type == Token::MULTOP)
            new_node = AST.new(@lookahead)
            match(Token::MULTOP)
            new_node.addAsFirstChild(factor())
            new_node.addAsFirstChild(node)
            return ttail(new_node)
        elsif (@lookahead.type == Token::DIVOP)
            new_node = AST.new(@lookahead)
            match(Token::DIVOP)
            new_node.addAsFirstChild(factor())
            new_node.addAsFirstChild(node)
            return ttail(new_node)
		else
			return node
        end
    end

    def etail(node)
        if (@lookahead.type == Token::ADDOP)
            new_node = AST.new(@lookahead)
            match(Token::ADDOP)
            new_node.addAsFirstChild(term())
            new_node.addAsFirstChild(node)
            return etail(new_node)
        elsif (@lookahead.type == Token::SUBOP)
            new_node = AST.new(@lookahead)
            match(Token::SUBOP)
            new_node.addAsFirstChild(term())
            new_node.addAsFirstChild(node)
		else
			return node
        end
    end

    def assign()
        assgn = AST.new(Token.new("assignment","assignment"))
		if (@lookahead.type == Token::ID)
			idtok = AST.new(@lookahead)
			match(Token::ID)
			if (@lookahead.type == Token::ASSGN)
				assgn = AST.new(@lookahead)
				assgn.addChild(idtok)
            	match(Token::ASSGN)
				assgn.addChild(exp())
        	else
				match(Token::ASSGN)
			end
		else
			match(Token::ID)
        end
		return assgn
	end
end

