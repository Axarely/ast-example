%{
#include "ast.h"
#include <stdio.h>
#include <stdlib.h>

extern int yylex();
void yyerror(const char *s);

ASTNode *ast_root = NULL;
%}

%union {
    int int_val;
    char *str_val;
    struct ASTNode *node;
}

%token TOKEN_VAR TOKEN_CONST
%token TOKEN_TRUE TOKEN_FALSE
%token <str_val> TOKEN_TYPE
%token <str_val> TOKEN_IDENTIFIER
%token <str_val> TOKEN_STRING_LITERAL
%token <int_val> TOKEN_INT_LITERAL

//any of these non-terminal rules produce a result
%type <node> program statement_list statement var_declaration expression

%%

program:
    statement_list {
        ast_root = $1;
    }
    ;

statement_list:
    statement {
        $$ = $1;
    }
    | statement_list statement {
        /* Append to linked list */
        ASTNode *cur = $1;
        while (cur->next != NULL) {
            cur = cur->next;
        }
        cur->next = $2;
        $$ = $1;
    }
    ;

statement:
    var_declaration ';' {
        $$ = $1;
    }
    ;

var_declaration:
    TOKEN_VAR ':' TOKEN_TYPE TOKEN_IDENTIFIER '=' expression {
        $$ = create_var_decl($3, $4, $6);
        free($3);
        free($4);
    }
    | TOKEN_VAR ':' TOKEN_TYPE TOKEN_IDENTIFIER {
      $$ = create_var_decl($3, $4, NULL);
        free($3);
        free($4);

    }
    | TOKEN_CONST ':' TOKEN_TYPE TOKEN_IDENTIFIER '=' expression {
        /* A constant must always be initialized */
        $$ = create_var_decl($3, $4, $6);
        $$->varDeclaration.isConst = 1;
        free($3);
        free($4);
    }
    ;

expression:
    TOKEN_INT_LITERAL {
        $$ = create_int_node($1);
    }
    | TOKEN_STRING_LITERAL {
        $$ = create_str_node($1);
        free($1);
    }
    | TOKEN_TRUE {
        $$ = create_bool_node(1);
    }
    | TOKEN_FALSE {
        $$ = create_bool_node(0);
    }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Parse error: %s\n", s);
}


