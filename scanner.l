%{
#include "ast.h"
#include "parser.tab.h"
#include <string.h>
#include <stdlib.h>
%}

%option noyywrap

%%

[ \t\r\n]+             ; /* Skip whitespace */

"var"                  { return TOKEN_VAR; }
"const"                { return TOKEN_CONST; }

"int"|"char"|"bool"|"str" { yylval.str_val = strdup(yytext); return TOKEN_TYPE; }

"true"                 { return TOKEN_TRUE; }
"false"                { return TOKEN_FALSE; }

":"                    { return ':'; }
"="                    { return '='; }
";"                    { return ';'; }


\"([^\\\"]|\\.)*\"     {
                         /* Strip quotes */
                         yytext[yyleng - 1] = '\0';
                         yylval.str_val = strdup(yytext + 1);
                         return TOKEN_STRING_LITERAL;
                       }

[0-9]+                 { yylval.int_val = atoi(yytext); return TOKEN_INT_LITERAL; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.str_val = strdup(yytext); return TOKEN_IDENTIFIER; }

.                      { fprintf(stderr, "Unexpected char: %s\n", yytext); }

%%
