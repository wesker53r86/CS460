/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Copyright (C) 1998,99 Gerwin Klein <kleing@informatik.tu-muenchen.de>.  *
 * All rights reserved.                                                    *
 *                                                                         *
 * This program is free software; you can redistribute it and/or modify    *
 * it under the terms of the GNU General Public License. See the file      *
 * COPYRIGHT for more information.                                         *
 *                                                                         *
 * This program is distributed in the hope that it will be useful,         *
 * but WITHOUT ANY WARRANTY; without even the implied warranty of          *
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           *
 * GNU General Public License for more details.                            *
 *                                                                         *
 * You should have received a copy of the GNU General Public License along *
 * with this program; if not, write to the Free Software Foundation, Inc., *
 * 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA                 *
 *                                                                         *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */


/* Java 1.2 language lexer specification */

/* Note, that this lexer specification is not tuned for speed.
   It is in fact quite slow on integer and floating point literals, 
   because the input is read twice and the methods used to parse
   the numbers are not very fast. 
   For a real world application (e.g. a Java compiler) this can 
   and should be optimized */

package Scanner;

import AST.*;
import Parser.*;

%%

%class Scanner
%public 
%7bit
%pack

%cup

%line
%column

%{
  public static String curLine = "";
  public static int lineCount = 0;	
  public static boolean debug = false;

  public void addToLine(String s, int line) {
    if (line != lineCount) 
      curLine = s;
    else
      curLine = curLine + s;
    lineCount = line;
  }


 private java_cup.runtime.Symbol token(int kind) {
    Token t;    
    addToLine(yytext(), yyline+1);
    t = new Token(kind, yytext(), yyline+1, yycolumn+1, yycolumn + yylength());
    if (debug)
      System.out.println(t);
    return new java_cup.runtime.Symbol(kind, t);
  }
%}


/* Main Character Classes */
LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]

WhiteSpace = {LineTerminator} | [ \t\f]

/* Comments */
Comment = {TraditionalComment} | {EndOfLineComment} | {DocumentationComment}

TraditionalComment = "/*" [^*] {CommentContent} \*+ "/"
UnterminatedComment = "/*" [^*] {CommentContent} \** "/"?
EndOfLineComment = "//" {InputCharacter}* {LineTerminator}
DocumentationComment = "/**" {CommentContent} \*+ "/"

CommentContent = ( [^*] | \*+[^*/] )*

/* Identifiers */
Identifier = [:jletter:][:jletterdigit:]*

/* Integer Literals */
DecIntegerLiteral = 0 | [1-9][0-9]*
DecLongLiteral    = {DecIntegerLiteral} [lL]
 
HexIntegerLiteral = 0 [xX] 0* {HexDigit} {1,8}
HexLongLiteral    = 0 [xX] 0* {HexDigit} {1,16} [lL]
HexDigit          = [0-9a-fA-F]
 
OctIntegerLiteral = 0+ [1-3]? {OctDigit} {1,15}
OctLongLiteral    = 0+ 1? {OctDigit} {1,21} [lL]
OctDigit          = [0-7]      

/* Floating Point Literals */
FloatLiteral  = ({FLit1}|{FLit2}|{FLit3}|{FLit4}) [fF]
DoubleLiteral = {FLit1}|{FLit2}|{FLit3}|{FLit4} 
 
FLit1 = [0-9]+ \. [0-9]* {Exponent}?
FLit2 = \. [0-9]+ {Exponent}?
FLit3 = [0-9]+ {Exponent}
FLit4 = [0-9]+ {Exponent}?
 
Exponent = [eE] [+\-]? [0-9]+       
 
/* String Literals */
StringCharacter = [^\r\n\"\\]
SingleCharacter = [^\r\n\'\\]
StringEscape  =   \\([btnfr"'\\]|[0-3]?{OctDigit}?{OctDigit}|u{HexDigit}{HexDigit}{HexDigit}{HexDigit}) 

%%

  /* Keywords */
  "abstract"                     { return token(sym.ABSTRACT); }
  "boolean"                      { return token(sym.BOOLEAN); } 
  "break"                        { return token(sym.BREAK); }  
  "class"			 { return token(sym.CLASS); }  
  "interface"			 { return token(sym.INTERFACE); }  

  "BOOLEAN_LITERAL"		 { return token(sym.BOOLEAN_LITERAL); } 

  
  // YOUR CODE HERE
  "byte"			 { return token(sym.BYTE);}
  "short"			 { return token(sym.SHORT);}
  "int"				 { return token(sym.INT);}
  "long" 			 { return token(sym.LONG);}
  "float"			 { return token(sym.FLOAT);}
  "double"			 { return token(sym.DOUBLE);}
  "char"			 { return token(sym.CHAR);}
  "String"			 { return token(sym.STRING);}
  "import"			 { return token(sym.IMPORT);}
  "public"			 { return token(sym.PUBLIC);}
  "private"			 { return token(sym.PRIVATE);}
  "static"			 { return token(sym.STATIC);}
  "final"			 { return token(sym.FINAL);}
  "extends"			 { return token(sym.EXTENDS);}
  "implements"			 { return token(sym.IMPLEMENTS);}
  "static"			 { return token(sym.STATIC);}
  "super"			 { return token(sym.SUPER);}
  "this"			 { return token(sym.THIS);)
  "extends"			 { return token(sym.EXTENDS);}
  "if"				 { return token(sym.IF);}
  "do"				 { return token(sym.DO);}
  "while"			 { return token(sym.WHILE);}
  "switch"			 { return token(sym.SWITCH);}
  "case"			 { return token(sym.CASE);}
  "default"			 { return token(sym.DEFAULT);}
  "for"				 { return token(sym.FOR);}
  "continue"			 { return token(sym.CONTINUE);}
  "return"			 { return token(sym.RETURN);}
  "new"				 { return token(sym.NEW);}
  "void"			 { return token(sym.VOID); }
  "instanceof" 			 { return token(sym.INSTANCEOF); }
  "else"			 { return token(sym.ELSE); }
  //End CODE HERE

  /* Boolean Literals */	   
  // YOUR CODE HERE  	

			   
  /* Null Literal */		   
  "null"                         { return token(sym.NULL_LITERAL); } 
  				     				   
  /* Separators */		   
  "("                            { return token(sym.LPAREN); } 
  // YOUR CODE HERE
  ")"				 { return token(sym.RPAREN);}
  "{"				 { return token(sym.LBRACE);}
  "}"				 { return token(sym.RBRACE);}
  "["				 { return token(sym.LBRACK);}
  "]"				 { return token(sym.RBRACK);}

  // END CODE HERE
  				   
  /* Operators */		   
  "="                            { return token(sym.EQ); }
  "+"				 { return token(sym.PLUS); }
  "-"				 { return token(sym.MINUS); }
  "/"				 { return token(sym.DIV); }
  "*"				 { return token(sym.MULT); }
  "++"				 { return token(sym.PLUSPLUS); }
  "--"				 { return token(sym.MINUSMINUS); }
  ","				 { return token(sym.COMMA); }
  ":"				 { return token(sym.COLON); }
  ";"				 { return token(sym.SEMICOLON); }
  "<<"				 { return token(sym.LSHIFT); }
  ">>"				 { return token(sym.RSHIFT); }
  ">>>"				 { return token(sym.RRSHIFT); }
  "<"				 { return token(sym.LT); }
  ">"				 { return token(sym.GT); }
  "<="				 { return token(sym.LTEQ); }
  ">="				 { return token(sym.GTEQ); }
  "=="				 { return token(sym.EQEQ); }
  "!="				 { return token(sym.NOTEQ); }
  "&"				 { return token(sym.AND); }
  "&&"				 { return token(sym.ANDAND); }
  "^"				 { return token(sym.XOR); }
  "|"				 { return token(sym.OR); }
  "||"				 { return token(sym.ANDAND); }
  "?"				 { return token(sym.QUEST); }
  "*="				 { return token(sym.MULTEQ); }
  "/="				 { return token(sym.DIVEQ); }
  "%="				 { return token(sym.MODEQ); }
  "*/"				 { return token(sym.PLUSEQ); }
  "-/"				 { return token(sym.MINUSEQ); }
  "<<="				 { return token(sym.LSHIFTEQ); }
  ">>="				 { return token(sym.RSHIFTEQ); }
  ">>>="			 { return token(sym.RRSHIFTEQ); }
  "&="				 { return token(sym.ANDEQ); }
  "^="				 { return token(sym.XOREQ); }
  "|="				 { return token(sym.OREQ); }
// YOUR CODE HERE

  /* Numeric literals */

  {DecIntegerLiteral}            { return token(sym.INTEGER_LITERAL); }
  {DecLongLiteral}               { return token(sym.LONG_LITERAL); }
 
  {HexIntegerLiteral}            { return token(sym.INTEGER_LITERAL); }
  {HexLongLiteral}               { return token(sym.LONG_LITERAL); }
 
  {OctIntegerLiteral}            { return token(sym.INTEGER_LITERAL); }
  {OctLongLiteral}               { return token(sym.LONG_LITERAL); }
 
  {FloatLiteral}                 { return token(sym.FLOAT_LITERAL); }
  {DoubleLiteral}                { return token(sym.DOUBLE_LITERAL); }
  {DoubleLiteral}[dD]            { return token(sym.DOUBLE_LITERAL); }
  

  /* String Literals */
	
  \"({StringCharacter})*\" { return token(sym.STRING_LITERAL); }
  \"({StringCharacter})*{LineTerminator} { throw new RuntimeException("Unterminated string at end-of-line \""+yytext()+"\" at line "+(yyline+1)+", column "+(yycolumn+1));
}

  /* character literal */
  \'{SingleCharacter}\'          { return token(sym.CHARACTER_LITERAL); }
  \'{StringEscape}\'             { return token(sym.CHARACTER_LITERAL); }
  \'{SingleCharacter}?{LineTerminator} { throw new RuntimeException("Unterminated character at end-of-line \""+yytext()+"\" at line "+(yyline+1)+", column "+(yycolumn+1)); }
  \'{StringEscape}?{LineTerminator} { throw new RuntimeException("Unterminated character at end-of-line \""+yytext()+"\" at line "+(yyline+1)+", column "+(yycolumn+1)); }   




  /* Comments */
  {Comment}                      { addToLine(yytext(), yyline+1); }
  {UnterminatedComment}		 { throw new RuntimeException("Unterminated comment at EOF at line "+(yyline+1)+", column "+(yycolumn+1)); }
  /* whitespace */
  {WhiteSpace}                   { addToLine(yytext(), yyline+1); }

  /* Identifiers */ 
  {Identifier
}                   { return token(sym.IDENTIFIER); } 


/* error fallback */
.|\n                             { throw new RuntimeException("Illegal character \""+yytext()+"\" at line "+(yyline+1)+", column "+(yycolumn+1)); }
