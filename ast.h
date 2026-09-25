#ifndef AST_H
#define AST_H

typedef enum {
  VAR_DECL,
  INT_LITERAL,
  STR_LITERAL,
  BOOL_LITERAL,
} NodeType;

typedef struct VarDeclaration {
  char *dataType;
  char *identifier;
  struct ASTNode *init;
  int isConst; // 1 = const, 0 = var
} VarDeclaration;

typedef struct ASTNode {
  NodeType type;
  union {
    struct VarDeclaration varDeclaration;
    struct {
      int intValue;
    } intLit;
    struct {
      char *strValue;
    } strLit;
    struct {
      int value; // 1 = true, 0 = false
    } boolLit;
  };

  struct ASTNode *next; //Linked list for multiple statements

} ASTNode;


ASTNode* create_int_node(int val);
ASTNode* create_str_node(const char *val);
ASTNode* create_bool_node(int val);
ASTNode* create_var_decl(char *dtype, const char *name, ASTNode *init);
void print_ast(ASTNode *root);
void free_ast(ASTNode *node);

#endif
