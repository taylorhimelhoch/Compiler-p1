%{
#include <string>
#include <limits.h>

/* Get our custom yyFlexScanner subclass */
#include "lexer.hpp"
#include "tokens.hpp"
#undef  YY_DECL
#define YY_DECL int cminusminus::Scanner::yylex( cminusminus::Parser::semantic_type * const lval )

/* define yyterminate as this instead of NULL */
#define yyterminate() return( TokenKind::END )

/* Exclude unistd.h for Visual Studio compatability. */
#define YY_NO_UNISTD_H

/* typedef to make the reference to token kinds shorter */
using TokenKind = cminusminus::Parser::token;

%}

%option debug
%option nodefault
%option yyclass="cminusminus::Scanner"
%option noyywrap
%option c++

DIGIT [0-9]
LETTER [a-z]


%%
%{          /** Code executed at the beginning of yylex **/
            yylval = lval;
%}

"int"    {
        int tokenKind = TokenKind::INT;
        Position * pos = new Position(
            lineNum, colNum, lineNum, colNum+3);
        this->yylval->lexeme = new Token(pos, tokenKind);
        colNum += 3;
        return tokenKind;
}

"short"    {
        int tokenKind = TokenKind::SHORT;
        Position * pos = new Position(
            lineNum, colNum, lineNum, colNum+5);
        this->yylval->lexeme = new Token(pos, tokenKind);
        colNum += 5;
        return tokenKind;
}

"bool"    {
        int tokenKind = TokenKind::BOOL;
        Position * pos = new Position(
            lineNum, colNum, lineNum, colNum+4);
        this->yylval->lexeme = new Token(pos, tokenKind);
        colNum += 4;
        return tokenKind;
}

"string"    {
        int tokenKind = TokenKind::STRING;
        Position * pos = new Position(
            lineNum, colNum, lineNum, colNum+6);
        this->yylval->lexeme = new Token(pos, tokenKind);
        colNum += 6;
        return tokenKind;
}

"void"    {
        int tokenKind = TokenKind::VOID;
        Position * pos = new Position(
            lineNum, colNum, lineNum, colNum+4);
        this->yylval->lexeme = new Token(pos, tokenKind);
        colNum += 4;
        return tokenKind;
}

"ptr"    {
        int tokenKind = TokenKind::PTR;
        Position * pos = new Position(
            lineNum, colNum, lineNum, colNum+3);
        this->yylval->lexeme = new Token(pos, tokenKind);
        colNum += 3;
        return tokenKind;
}

"gets"    {
        int tokenKind = TokenKind::ASSIGN;
        Position * pos = new Position(
            lineNum, colNum, lineNum, colNum+4);
        this->yylval->lexeme = new Token(pos, tokenKind);
        colNum += 4;
        return tokenKind;
}

"if"    {
        int tokenKind = TokenKind::IF;
        Position * pos = new Position(
            lineNum, colNum, lineNum, colNum+2);
        this->yylval->lexeme = new Token(pos, tokenKind);
        colNum += 2;
        return tokenKind;
}

"else"    {
        int tokenKind = TokenKind::ELSE;
        Position * pos = new Position(
            lineNum, colNum, lineNum, colNum+4);
        this->yylval->lexeme = new Token(pos, tokenKind);
        colNum += 4;
        return tokenKind;
}

"while"    {
        int tokenKind = TokenKind::WHILE;
        Position * pos = new Position(
            lineNum, colNum, lineNum, colNum+5);
        this->yylval->lexeme = new Token(pos, tokenKind);
        colNum += 5;
        return tokenKind;
}

"return"    {
        int tokenKind = TokenKind::RETURN;
        Position * pos = new Position(
            lineNum, colNum, lineNum, colNum+6);
        this->yylval->lexeme = new Token(pos, tokenKind);
        colNum += 6;
        return tokenKind;
}

"true"    {
        int tokenKind = TokenKind::TRUE;
        Position * pos = new Position(
            lineNum, colNum, lineNum, colNum+4);
        this->yylval->lexeme = new Token(pos, tokenKind);
        colNum += 4;
        return tokenKind;
}

"false"    {
        int tokenKind = TokenKind::FALSE;
        Position * pos = new Position(
            lineNum, colNum, lineNum, colNum+5);
        this->yylval->lexeme = new Token(pos, tokenKind);
        colNum += 5;
        return tokenKind;
}

"read"    {
        int tokenKind = TokenKind::READ;
        Position * pos = new Position(
            lineNum, colNum, lineNum, colNum+4);
        this->yylval->lexeme = new Token(pos, tokenKind);
        colNum += 4;
        return tokenKind;
}

"write"    {
        int tokenKind = TokenKind::WRITE;
        Position * pos = new Position(
            lineNum, colNum, lineNum, colNum+5);
        this->yylval->lexeme = new Token(pos, tokenKind);
        colNum += 5;
        return tokenKind;
}

"or"    {
        int tokenKind = TokenKind::OR;
        Position * pos = new Position(
            lineNum, colNum, lineNum, colNum+2);
        this->yylval->lexeme = new Token(pos, tokenKind);
        colNum += 2;
        return tokenKind;
}

"and"    {
        int tokenKind = TokenKind::AND;
        Position * pos = new Position(
            lineNum, colNum, lineNum, colNum+3);
        this->yylval->lexeme = new Token(pos, tokenKind);
        colNum += 3;
        return tokenKind;
}

[_a-zA-Z][_a-zA-Z0-9]* {
        

        Position * pos = new Position(
            lineNum, colNum, lineNum, colNum+strlen(yytext));

        this->yylval->lexeme = new IDToken(pos, yytext);
        colNum += strlen(yytext);
        return TokenKind::ID;
}

"+"        {
        // Keep track of the "kind" of token we matched. In this case,
        // it's a PLUS (aka the plus symbol). The full list of token
        // kinds is declared around line 197 of grammar.hh. The testing
        // functionScanner::outputTokens also indicates what each token
        // represents (declared in scanner.cpp line 9)
        int tokenKind = TokenKind::PLUS;

        Position * pos = new Position(
            lineNum, colNum, lineNum, colNum+1);

        //Instatiate a token. There are 5 classes of tokens defined based on
        // - a literal string (StringLitToken)
        // - a literal integer (IntLitToken)
        // - a literal short (ShortLitToken)
        // - an identifier (IDToken)
        // - a base Token (any other type)
        // The token object is a handy place to keep information about the
        // token (i.e. token metadata) such as the line and column on which
        // the token character started (which can be used later in debug
        // messages, etc).
        Token * token = new Token(pos, tokenKind);

        //Assign the token to a instance variable of the scanner.
        // (When Flex processes a .l file in C++ mode, it creates
        // a class called Scanner, which is a subclass of yyFlexScanner)
        // By assigning a value to this field, we put the token
        // metadata in a place where scanner's client program can find it.
        this->yylval->lexeme = token;

        //Since we consumed 1 character, increase the column number by 1
        colNum++;

        //Let the scanner's client program know that a PLUS token
        // has been matched
        return tokenKind;
        }

"-" {
        //Essentially the same thing as PLUS, but without the verbose
        // comments so it doesn't look so scary.
        int tokenKind = TokenKind::MINUS;
        Position * pos = new Position(
            lineNum, colNum, lineNum, colNum+1);
        this->yylval->lexeme = new Token(pos, tokenKind);
        colNum++;
        return tokenKind;
        }

"{" {
    int tokenKind = TokenKind::LCURLY;
    Position * pos = new Position(
        lineNum, colNum, lineNum, colNum+1);
    Token * token = new Token(pos, tokenKind);
    this->yylval->lexeme = token;
    colNum+=yyleng;
    return tokenKind;
    }

"}" {
    int tokenKind = TokenKind::RCURLY;
    Position * pos = new Position(
        lineNum, colNum, lineNum, colNum+1);
    Token * token = new Token(pos, tokenKind);
    this->yylval->lexeme = token;
    colNum+=yyleng;
    return tokenKind;
    }

"(" {
    int tokenKind = TokenKind::LPAREN;
    Position * pos = new Position(
        lineNum, colNum, lineNum, colNum+1);
    Token * token = new Token(pos, tokenKind);
    this->yylval->lexeme = token;
    colNum+=yyleng;
    return tokenKind;
    }

")" {
    int tokenKind = TokenKind::RPAREN;
    Position * pos = new Position(
        lineNum, colNum, lineNum, colNum+1);
    Token * token = new Token(pos, tokenKind);
    this->yylval->lexeme = token;
    colNum+=yyleng;
    return tokenKind;
    }

";" {
    int tokenKind = TokenKind::SEMICOL;
    Position * pos = new Position(
        lineNum, colNum, lineNum, colNum+1);
    Token * token = new Token(pos, tokenKind);
    this->yylval->lexeme = token;
    colNum+=yyleng;
    return tokenKind;
    }

"@" {
    int tokenKind = TokenKind::AT;
    Position * pos = new Position(
        lineNum, colNum, lineNum, colNum+1);
    Token * token = new Token(pos, tokenKind);
    this->yylval->lexeme = token;
    colNum+=yyleng;
    return tokenKind;
    }

"&" {
    int tokenKind = TokenKind::AND;
    Position * pos = new Position(
        lineNum, colNum, lineNum, colNum+1);
    Token * token = new Token(pos, tokenKind);
    this->yylval->lexeme = token;
    colNum+=yyleng;
    return tokenKind;
    }

"," {
    int tokenKind = TokenKind::COMMA;
    Position * pos = new Position(
        lineNum, colNum, lineNum, colNum+1);
    Token * token = new Token(pos, tokenKind);
    this->yylval->lexeme = token;
    colNum+=yyleng;
    return tokenKind;
    }

"--" {
    int tokenKind = TokenKind::DEC;
    Position * pos = new Position(
        lineNum, colNum, lineNum, colNum+1);
    Token * token = new Token(pos, tokenKind);
    this->yylval->lexeme = token;
    colNum+=yyleng;
    return tokenKind;
    }

"*" {
    int tokenKind = TokenKind::TIMES;
    Position * pos = new Position(
        lineNum, colNum, lineNum, colNum+1);
    Token * token = new Token(pos, tokenKind);
    this->yylval->lexeme = token;
    colNum+=yyleng;
    return tokenKind;
    }

"=" {
    int tokenKind = TokenKind::ASSIGN;
    Position * pos = new Position(
        lineNum, colNum, lineNum, colNum+1);
    Token * token = new Token(pos, tokenKind);
    this->yylval->lexeme = token;
    colNum+=yyleng;
    return tokenKind;
    }

"!" {
    int tokenKind = TokenKind::NOT;
    Position * pos = new Position(
        lineNum, colNum, lineNum, colNum+1);
    Token * token = new Token(pos, tokenKind);
    this->yylval->lexeme = token;
    colNum+=yyleng;
    return tokenKind;
    }

"/" {
    int tokenKind = TokenKind::DIVIDE;
    Position * pos = new Position(
        lineNum, colNum, lineNum, colNum+1);
    Token * token = new Token(pos, tokenKind);
    this->yylval->lexeme = token;
    colNum+=yyleng;
    return tokenKind;
    }

"++" {
    int tokenKind = TokenKind::INC;
    Position * pos = new Position(
        lineNum, colNum, lineNum, colNum+1);
    Token * token = new Token(pos, tokenKind);
    this->yylval->lexeme = token;
    colNum+=yyleng;
    return tokenKind;
    }

"==" {
    int tokenKind = TokenKind::EQUALS;
    Position * pos = new Position(
        lineNum, colNum, lineNum, colNum+1);
    Token * token = new Token(pos, tokenKind);
    this->yylval->lexeme = token;
    colNum+=yyleng;
    return tokenKind;
    }

"!=" {
    int tokenKind = TokenKind::NOTEQUALS;
    Position * pos = new Position(
        lineNum, colNum, lineNum, colNum+1);
    Token * token = new Token(pos, tokenKind);
    this->yylval->lexeme = token;
    colNum+=yyleng;
    return tokenKind;
    }

"<" {
    int tokenKind = TokenKind::LESS;
    Position * pos = new Position(
        lineNum, colNum, lineNum, colNum+1);
    Token * token = new Token(pos, tokenKind);
    this->yylval->lexeme = token;
    colNum+=yyleng;
    return tokenKind;
    }

">" {
    int tokenKind = TokenKind::GREATER;
    Position * pos = new Position(
        lineNum, colNum, lineNum, colNum+1);
    Token * token = new Token(pos, tokenKind);
    this->yylval->lexeme = token;
    colNum+=yyleng;
    return tokenKind;
}

"<=" {
    int tokenKind = TokenKind::LESSEQ;
    Position * pos = new Position(
        lineNum, colNum, lineNum, colNum+1);
    Token * token = new Token(pos, tokenKind);
    this->yylval->lexeme = token;
    colNum+=yyleng;
    return tokenKind;
}

">=" {
    int tokenKind = TokenKind::GREATEREQ;
    Position * pos = new Position(
        lineNum, colNum, lineNum, colNum+1);
    Token * token = new Token(pos, tokenKind);
    this->yylval->lexeme = token;
    colNum+=yyleng;
    return tokenKind;
}

{DIGIT}+    {
        //TODO: The following computation of the integer
        // value does not check for overflow. It should do so.
        int intVal = atoi(yytext);

        int MAX_INT = 100000000;

        if(intVal > MAX_INT)
        {
            std::string msg = "Integer literal overflow ";
            Position * pos = new Position(
                lineNum, colNum, lineNum, colNum+strlen(yytext)
            );

            yylval->lexeme = new IntLitToken(pos, intVal);
            
            Report::fatal(pos,msg);
            colNum += strlen(yytext);
            
            return TokenKind::INTLITERAL;
            
        }
        else
        {
                
        Position * pos = new Position(
            lineNum, colNum, lineNum, colNum+strlen(yytext));
        yylval->lexeme = new IntLitToken(pos, intVal);

     
        std::string str(yytext);
        int intLength = str.length();
        colNum += intLength;

        return TokenKind::INTLITERAL;
        }
    }

([0-9]+S)    {
    std::string str(yytext);
    long intVal = atoi(yytext);

    if(intVal <32767 && intVal > -32768){
        Position * pos = new Position(
            lineNum, colNum, lineNum, colNum+strlen(yytext));
        yylval->lexeme = new ShortLitToken(pos, intVal);

        int intLength = str.length();
        colNum += intLength;

        return TokenKind::SHORTLITERAL;
    }

    else{
        if(intVal > 32767){
            std::string msg = "Short literal overflow ";
            Position * pos = new Position(
                lineNum, colNum, lineNum, colNum+strlen(yytext));
            Report::fatal(pos,msg);
            colNum += strlen(yytext);
        }
        else{
            std::string msg = "Short literal underflow ";
            Position * pos = new Position(
                lineNum, colNum, lineNum, colNum+strlen(yytext));
            Report::fatal(pos,msg);
            colNum += strlen(yytext);
        }
    }
}

\"(\\(n|t|\"|\\)|[^\n\"\\])*\" {
    Position* pos = new Position(lineNum, colNum, lineNum, colNum+strlen(yytext));
    yylval->lexeme = new StrToken(pos, yytext);
    colNum += strlen(yytext);
    return TokenKind::STRLITERAL;
}

\"(\\(n|t|\"|\\)|[^\n\"\\])* {
    Position* pos = new Position(lineNum, colNum, lineNum, colNum+strlen(yytext));
    colNum += strlen(yytext);
    errStrUnterm(pos);
}

\"(\\[^nt\"\n\\]|[^\n\"])*\" {
    Position* pos = new Position(lineNum, colNum, lineNum, colNum+strlen(yytext));
    colNum += strlen(yytext);
    errStrEsc(pos);
}

\"(\\[^nt\"\n\\]|[^\n\"])* {
    Position* pos = new Position(lineNum, colNum, lineNum, colNum+strlen(yytext));
    colNum += strlen(yytext);
    errStrEscAndUnterm(pos);
}


#.* { }

[ \t] { colNum++; }

\n        {
        //Update the line number, reset the columnNumber
        lineNum++;
        colNum = 1;
        }


.   {
        //TODO: Add the rest of the rules above this point so that legal characters
        // are properly accounted for.
        std::string msg = "Illegal character ";
        msg += yytext;
        Position * pos = new Position(
            lineNum, colNum, lineNum, colNum+1);
        Report::fatal(pos,msg);
        colNum += strlen(yytext);
    }
%%
